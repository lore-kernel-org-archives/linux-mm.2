Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAB6FC5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 19:16:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94DEF6B0093; Mon, 10 Aug 2026 15:16:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9266B6B0095; Mon, 10 Aug 2026 15:16:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 815756B0096; Mon, 10 Aug 2026 15:16:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A3A66B0093
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:16:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 03587A20A5
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 19:16:57 +0000 (UTC)
X-FDA: 85086317316.06.A951762
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2522810000B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 19:16:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e0u4e1Wq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=cmllamas@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786389416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J2OElYLJIGARf5vioBp76ZtfppNwzknP+qKxG2O0wiw=;
	b=KfQ9JbMrghEAU0nLd9x/VgGWEGWcL2zx+hu9jSORr3pxchB3YxRc5tEyYl+U4plpNPMnXz
	3vr00zsxbW+6YlaQmotFlm/kQLdc3TCcWo1ecaq8ORG5CjHSB/LLexAU1IYA2YlC1K/VoX
	CQAEI9vI3+Y/WYkVA9ijeULk6gJFV4Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e0u4e1Wq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=cmllamas@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786389416;
	b=7BFU18JWgzg5+m+sM33LZaYG4lgnEwbDsuZV0QrHvkUn6wqhx5/JJuDcPxNpksz80HCx3E
	1J6QNWuYb2VkWdYASa8oahD70hhE5EUUSggCj/av6HXjezvYy2LHwKF3//iv91aXnVVdpH
	TOonHHdoBza6YMHpPtGTxHeD7ORGCRQ=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2cacef7d299so24565ad.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786389415; x=1786994215; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=J2OElYLJIGARf5vioBp76ZtfppNwzknP+qKxG2O0wiw=;
        b=e0u4e1WqlrXdLRpbhTnaeD2LcBwHHeKw5cbvx5OfZujcM6D2AIRRhJu1eSh/AgAfb9
         bQWRlu2z6+gTr3nYubnn7Z640WT9NEacwINUXr5DWef4IbjA2cz/H7Ptbdd1B8z7+gzt
         7oJ+6RpYZ27pr/KCtd+890bBy+UvBmFOb8tnk3YOpOwHYfRAmmXQnFgFdrua7PF0xQeF
         P8DM2WwmvWDZQFp7nWUH7C+2HdD8qV08+bdw7VD34rfgMQmlzAgnG8ztiAiGrIUGhJ3h
         9A1gq5UhSUF9J/gBcGtlYplFLKo6T82gAW/GvWfJXWVXoJaP+JqPV8/cmQv3SAX14e6l
         vqpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786389415; x=1786994215;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=J2OElYLJIGARf5vioBp76ZtfppNwzknP+qKxG2O0wiw=;
        b=R3kGTO165eAu2QW1+YdhrqpfGnS+L8NUhwUd4xHNtLdtVHvKbVj1KEwEED1mVmsFjT
         6wOoOBGTq82RXO3yLAjzBY8gerSkHJ3zjSWA+3fPvo2j98HjJnAp8dLlDKii4keHxPTV
         reUNLfXTBIDXL9NzMwdOpb8Zvq4IBib/1RohfK3p0DLj4S8TGA52TSEXSStGsTdS4CiD
         4HiRWMZ0WI5uOAWEd0hFQJNGQKkFqrJaEi8Bb+QA+BGNZeCzT4dYjvXfJvQPP1LCTSjp
         plt9nK8kRspDSPFJ5tkTibIGEOPMsOVzkrrJI2OP3K/lVXZO25AdKOForHq9VWdt5nTP
         c0gA==
X-Forwarded-Encrypted: i=1; AHgh+RrOw1Ok3jsdtBxB6Xfz5pb3XSkbntuuZJvm+LqZWdAhiauCELy8uL4GUPSaRSg3q1M7Y1pVUb2DuA==@kvack.org
X-Gm-Message-State: AOJu0YyBQECf51/1ZYvRt9QPhogJ0u4nKGxtVEU9n4tL0FK5v4mgmSQO
	Dq9ApF6+ocDE7m3PviyXFFVIF8Vkspm1gfsR5A5TxVm/lsREoEjxPmwltgfwAmAZXA==
X-Gm-Gg: AR+sD13Qs/9W5yCjF42J2SqFNIRN9Mn2tF32MHsyQjm9QQAk9SU/SVNFnWvAIbW0Fts
	pyLhR5H9Ulypblvx36iKGzSrp05rexo3MQCqrpm9ZuKBVgimoZH0Hvde/L5lkSKtTqdIK8tgeM7
	YO7YGu/lH4yaEYz8dQCZPaWzMmmUmG3+HTL5z4kdV5lRMvAJqJZBLLSAt2c/jhyishVKD0onSxn
	Ckq3AK6pIJiuNd9zsmnhwSwZR7OXDatpvcU19VlrDPdivj+Wy7OsNCYdK5iJmbPsoADV+T+ZpaJ
	L1K2hcoyNQOtW9hrrnk9l/vagW5OQmKO7bmJ0VcwzuWks/vkMjquEoPaoyOf3QJSideXjnjYbw+
	igwQrbUuBzOIfN+971oTTBl9fl3nkn2p1mMyqqRFremMuYeBAIs9qv47GZn9uhZGZ0Zi2hpLzkd
	0ZpKIshXiJ+j/CxU9MT8TuxrFyh4K8tOh/gStUY1pbqgT9gU/gYcfc+6nlmv8VnhskuV1LLfF3+
	WQDRpmhCPSIruY/GvpkPMmWG6lzKPnROg4N5IIRKwDgYd+anAAQkiug5Hlc4vnl5XAMHOS+jbOJ
	/gcZVRS6l/381QnjEPA=
X-Received: by 2002:a17:902:c64a:b0:2ca:be81:b469 with SMTP id d9443c01a7336-2d3102ed978mr1352925ad.0.1786389414159;
        Mon, 10 Aug 2026 12:16:54 -0700 (PDT)
Received: from google.com (193.67.125.34.bc.googleusercontent.com. [34.125.67.193])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe8f35b155sm4428211a12.16.2026.08.10.12.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 12:16:52 -0700 (PDT)
Date: Mon, 10 Aug 2026 19:16:48 +0000
From: Carlos Llamas <cmllamas@google.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com,
	Liam.Howlett@oracle.com, ljs@kernel.org, david@kernel.org,
	willy@infradead.org, shakeel.butt@linux.dev, vbabka@kernel.org,
	jannh@google.com, aliceryhl@google.com, arve@android.com,
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org,
	davem@davemloft.net, gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v4 2/5] binder: Make shrinker rely solely on per-VMA lock
Message-ID: <anojoFPijbCloUXL@google.com>
References: <20260806200548.3124802-1-surenb@google.com>
 <20260806200548.3124802-3-surenb@google.com>
 <anoZL76y3WGXMArB@google.com>
 <CAJuCfpFCK5ycO6s+dD35YtU6zgNdivfe6P3cVnd2VxPYfGXHDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFCK5ycO6s+dD35YtU6zgNdivfe6P3cVnd2VxPYfGXHDQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: aeaqc9oks4pxaezwsq6o8xs97pxstw73
X-Rspamd-Queue-Id: 2522810000B
X-HE-Tag: 1786389416-794628
X-HE-Meta: U2FsdGVkX1/kgeTkIXDlsL8SpbhZOOTv1oAnMbVbHP3SoIcDhZS1C5EwHRvuoXjsRVUNO+lc+PIadlDJbu/Waqtpi5tMchzFP2/Y3zP3tgEfj5CtDQm5Z7VA0f/bec/1tHTlts4l8aTF5hVdoxLZsQIEZRWwuA4BBjwDzXK4DR1+Fxvyn4YDayS78fJADuNH/g/ZjUZ5eafU+Pr+ormTzcUMqjdMCMc65O23MMmx1Z4C/EvgQzYCAT6jLRjjZjVdrhxDLx6mWmVdpNan5z7LmkxXMULcrZCbxdULy2nfD1Req54IHAA1ykZsPJHSrtWxBE/fmtML5XdssTg/74XZtwzHXyNrGbG6ohZckrKGKmB3A+8l4qlcz9Qa0Ujep7OCI+yB3fix8QEaCDFxjDcfX/6SISBU1AAMZryx8IfsIqwRcA4APRBTGnUBXQVvtEGQQPGtyha3qhrNCb0U4ZZmQhe++gYLAW+wbZq4MqBkzu0syASkb6C8kdFJaIaQHmT01vceviHijYngcYwosyG9ZI8H1iwy/1gULPAgZpyyvTCEz08v+ZqvmjgNiX4IpHq9G3YXMJgNlUGP1vCE7zU5fNuH044bBw3Ia7tXAE9mR/NAHUmlQTcwJz8xZ8FLJWJl3EdTqBxVtSSmm6V1ve4MH3ny9aG4wLnMtmiLUnZIKV+H9mwOp9oWuLZvyAiSMMB5023tWvcxSxiMcXtppQK3aaSttRxYOQxc+waxqhotd48AeAALTDnOTw/DX6omEPNl7rc7UJqWrR52+lIxAiqLiQQvazarksK7XjvLbxsTovvKBUlDcamD8V4PcWnyh3Im5FkrznDsAJxjsYZ6rHy7K9u5IsQmwi8dU0wiQA59bihq5kK9kvEiJUyP98aA+hfffZLxOO2x5hBtREksrb80dZ5J1Fbv1XxJarRnXmqapLmD+A7xX34H3K/Xtg4ATiVkZH9GCEd1ktGER+3W9Wz
 yG+voGVs
 vEzNwFkfP7Zax4M9MwyYsA5A9g5WqPSkNbj6gq6EdC/lLGNVcyTcBPW8Gcjc/AhobqcvwxEE7CKgQkILBb8JhQQZU4hv/3srWajLIF6lMTzRvXLsBxz0QxPOKCFqtCqj6j4CVQfXDyVSBloRSg9+8wKC36Zfc5EhOknx5OZhVcS0fnu615uI2LnTLMs8gY1kzM0Ugj5TEhaU/Hq6LiLiez7DiiOz/wTyoeBbafNthwmB8KeM5YNNeIBoW6Aab/lbAtF5TZjvuyRxNxzJh3XMUa7uzZdu4sq1u2JupkvWhQXSb8TEKSQ8jYXDnzZJk1K+6wUh2HprslqtWJqtqylfssywra7hGGMKcdAPHZlmEg0TV4/L+2HpQ3KbK+iUkcVAcb6Xpwze72Z0wy7P8o1AAZQQt2EA5XaX3Qg8Dutg++q3SIP+VUoubqKjZhe++955/eE79vQOz+/ufpaCPL6GGLTcCK3OxtAMfrz0n4bV8L4gk7KzXyYX54KU7i6OY2XZnaz+8FXP0wwA/ooJt8yvgOtrHUoctny5M64ThKrI4ropBH/lPv1vs8BkAS9E8RL1iQ15xU3wG+UAqAZH0oHr5fPJJeK8wygSM0DVUmC5fX0qjNdtwXOHYa16NgGCm/t8I3xTyPwe77sWf7P9eRCtK7agwrdRHnvLV54RS+AwOAvKDAgfCd5rFgfckNFHhgMC2v0cHzmx+m7b7M7YueQ6vdUxXYklh8PKx0eq28GHFPc9iFjgbmRnpOkn7WRQie6iqlNX2IWb8bzMBv/Gx97mmyLcDEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 11:54:04AM -0700, Suren Baghdasaryan wrote:
> On Mon, Aug 10, 2026 at 11:32 AM Carlos Llamas <cmllamas@google.com> wrote:
> >
> > On Thu, Aug 06, 2026 at 01:05:45PM -0700, Suren Baghdasaryan wrote:
> > > From: Dave Hansen <dave.hansen@linux.intel.com>
> > >
> > > tl;dr: lock_vma_under_rcu() is already a trylock. No need to do both
> > > it and mmap_read_trylock().
> > >
> > > Long Version:
> > >
> > > == Background ==
> > >
> > > Historically, binder used an mmap_read_trylock() in its shrinker code.
> > > This ensures that reclaim is not blocked on an mmap_lock. Commit
> > > 95bc2d4a9020 ("binder: use per-vma lock in page reclaiming") added
> > > support for the per-VMA lock, but left mmap_read_trylock() as a
> > > fallback.
> > >
> > > This was presumably because the per-VMA locking can fail for several
> > > reasons and most (all?) lock_vma_under_rcu() callers have a fallback
> > > to mmap_read_trylock().
> > >
> > > == Problem ==
> > >
> > > The fallback is not worth the complexity here. lock_vma_under_rcu() is
> > > essentially already a non-blocking trylock. The main reason it fails
> > > is also the reason mmap_read_trylock() fails: something is holding
> > > mmap_write_lock().
> > >
> > > The only remedy for a collision with mmap_write_lock() is to wait,
> > > which this code can not do. So the "fallback" after
> > > lock_vma_under_rcu() failure is not really a fallback: it is really
> > > likely to just be retrying in vain. That retry in an of itself isn't
> > > horrible. But it adds complexity.
> > >
> > > == Solution ==
> > >
> > > Now that per-VMA locks are universally available, lock_vma_under_rcu()
> > > will not persistently fail. Rely on it alone and simplify the code.
> > > The removal of the fallback does not affect NOMMU case because binder
> > > driver depends on CONFIG_MMU.
> > >
> > > Full disclosure: I originally tried to do this with
> > > lock_vma_under_rcu_wait(), but it did not fit well with the mmap_lock
> > > trylock semantics. Claude caught this in a review and suggested the
> > > approach in this path. It seemed sane to me. So, Suggesed-by: Claude,
> > > I guess.
> > >
> > > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > > Cc: Vlastimil Babka <vbabka@kernel.org>
> > > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > > Cc: linux-mm@kvack.org
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Cc: Arve Hjønnevåg <arve@android.com>
> > > Cc: Todd Kjos <tkjos@android.com>
> > > Cc: Christian Brauner <christian@brauner.io>
> > > Cc: Carlos Llamas <cmllamas@google.com>
> > > Cc: Alice Ryhl <aliceryhl@google.com>
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: David Ahern <dsahern@kernel.org>
> > > Cc: netdev@vger.kernel.org
> > > ---
> > >  drivers/android/binder_alloc.c | 45 ++++++++++++++++------------------
> > >  1 file changed, 21 insertions(+), 24 deletions(-)
> > >
> > > diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
> > > index e4488ad86a65..c13a588c37de 100644
> > > --- a/drivers/android/binder_alloc.c
> > > +++ b/drivers/android/binder_alloc.c
> > > @@ -1142,7 +1142,6 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
> > >       struct vm_area_struct *vma;
> > >       struct page *page_to_free;
> > >       unsigned long page_addr;
> > > -     int mm_locked = 0;
> > >       size_t index;
> > >
> > >       if (!mmget_not_zero(mm))
> > > @@ -1151,27 +1150,25 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
> > >       index = mdata->page_index;
> > >       page_addr = alloc->vm_start + index * PAGE_SIZE;
> > >
> > > -     /* attempt per-vma lock first */
> > > +     /*
> > > +      * Attempt per-vma lock. This is essentially a
> > > +      * "trylock". It can fail even if the VMA exists
> > > +      * for 'page_addr'.
> > > +      */
> >
> > Do we need to explain how lock_vma_under_rcu() works here?
> >
> > >       vma = lock_vma_under_rcu(mm, page_addr);
> > >       if (!vma) {
> > > -             /* fall back to mmap_lock */
> > > -             if (!mmap_read_trylock(mm))
> > > -                     goto err_mmap_read_lock_failed;
> > > -             mm_locked = 1;
> > > -             vma = vma_lookup(mm, page_addr);
> > > +             /*
> > > +              * If the vma exists, we can't continue because we cannot
> > > +              * remove the page from the vma. However, if the vma was
> > > +              * unmapped, it's okay to continue.
> > > +              */
> > > +             if (binder_alloc_is_mapped(alloc))
> > > +                     goto err_vma_lock_failed;
> >
> > The comments seem redundant, the label is enough. This works:
> >
> >         vma = lock_vma_under_rcu(mm, page_addr);
> >         if (!vma && binder_alloc_is_mapped(alloc))
> >                 goto err_vma_lock_failed;
> 
> Yeah, for the binder maintainers what's happening here is probably
> obvious, but when Alice explained the logic to me, this comment really
> clarified what's going on, so I added it here. If you insist on
> removing it, I'll do that of course.
> 
> >
> >
> > >       }
> > >
> > >       if (!mutex_trylock(&alloc->mutex))
> > >               goto err_get_alloc_mutex_failed;
> > >
> > > -     /*
> > > -      * Since a binder_alloc can only be mapped once, we ensure
> > > -      * the vma corresponds to this mapping by checking whether
> > > -      * the binder_alloc is still mapped.
> > > -      */
> > > -     if (vma && !binder_alloc_is_mapped(alloc))
> > > -             goto err_invalid_vma;
> > > -
> >
> > This introduces an "extra" change. We'll now release pages without a
> > valid vma (e.g. after munmap()). Before, these pages were expected to be
> > released via close() in binder_alloc_deferred_release() later.
> >
> > I don't see anything wrong with it. However, it does seem out of the
> > scope of this patch which just drops the mmap_read_lock() calls. Or at
> > least I don't see how this part is necessary.
> 
> This check came from this discussion:
> https://lore.kernel.org/all/anGrFIYiPhjxWSkD@google.com/
> It's added for consistency when handling cases where the original
> Binder VMA is gone.

Oh sorry I missed that thread. Yes, I agree we can reclaim these pages
earlier if really needed but my point is this is unrelated to the change
done here IMO. I couldn't figure out why that was needed.

If you are keeping that in the same commit it's probably worth adding an
explanation to the commit log?

--
Carlos Llamas

