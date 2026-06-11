Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D231CD8C9D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 20:00:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A70EB6B0005; Thu, 11 Jun 2026 16:00:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A217E6B0088; Thu, 11 Jun 2026 16:00:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9103B6B008C; Thu, 11 Jun 2026 16:00:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C7C26B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:00:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 15032C27AC
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:00:10 +0000 (UTC)
X-FDA: 84868698180.14.62DDEE6
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0B4F9C0003
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:00:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=holWlIw7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781208008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+DZhnLtU4hkHNEj9D5IMZ233IFNNjbtecRnYLHLtb/s=;
	b=UX8oxwq+MfkC0ieRKeLK/RREEDIZfom1NYq5LuwHG4ddyhpF3IvGKwpPFI96baaMwP3BID
	c7KlwUzeZeZlY2vHh4E6orL/6HaYNP03JLRny1ttF2hK38RZtw4XdshlbSVDBC1QQbuGek
	KmSk2R9XXfOUKXakHV2Wru6r0vLBR6Y=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=holWlIw7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781208008;
	b=LYZkX1TR+Q4YLbn1vzFJSmvkLNbfQVeYCl3B7EYWn5gygxQNLghOUBBvgo9tDiJr4KZ1qD
	qoGCAkCstg+zDDV4Wku8gfBv/Q/IDj86gbMzmXkGH+DicpELoaKXlTJstcv6VTyn4uP/Qo
	SCGtjIdRIXeyIMbWLmG1qVsCG3NREdg=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51765331535so18921cf.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:00:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781208007; cv=none;
        d=google.com; s=arc-20240605;
        b=Y+kHR9kaQz+VuZueO1I4uAgPbgqRYcr6frnf81Hk1MhgE5kteCpzf3XRm7kWOp3QgD
         tnhCKUPSWEX/AL/zoctLW469etHSZzv64zpX2kGDMAM+V6jw406rW94NmJTtMSDeKdnh
         uudRT2h7CytnH0tq3pW22xC3bS31SHwSUms26qVJ4Jj22UHhxRIRAXy2gGJUGJe0oPuP
         zniTueCsg40I7c7B7XPSBRv68IDnYZOmOQDFYAJCWaWXWwDVwQTD2Ua9sfW6g7/Bxo6v
         PMmHWXK7pnTebrmRtSzZBeRmmAbDdt1olrPh68FaJDZGi9bYnmeiNstM5Nl2cBWxa6Jj
         u0uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+DZhnLtU4hkHNEj9D5IMZ233IFNNjbtecRnYLHLtb/s=;
        fh=+IbIf8fJ9o0tQwdHYjCP1y9KjsQAlZdFgi/nKlixaxM=;
        b=jfpdMFl6deGF6VNz93EA8DzZvBJLBaWXKWy2wAbrIG/21X6ujdwGZIfr2AufSo7qo1
         gopnzKKA4NjBQ3jG4+CBVYMx0STYJ5kZ1FPIUOtL0P1eArBKz/ztAYzejltCZGkkvvI7
         L7uw5rRpaRkdcNPcS+aOlQFSbWbMaswjBCqZrBJ85XsdrJJ0aR4Z1Vip3cFS9Hqpetwz
         iqDoKfWpAqBcBQwwvTnXitMEjB/IT4015WMa9vMgiMl88RAGTKSLmQB9R277TSF2Izzx
         ak/1d24m27GglYRG4l2zvsxk7Fmq3M/AxWC3zKWWXyDcFH79OeoNFwojIQJoccH+K8hh
         ugNg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781208007; x=1781812807; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+DZhnLtU4hkHNEj9D5IMZ233IFNNjbtecRnYLHLtb/s=;
        b=holWlIw7iAWs2bgHaR1hWmYu8BJ4DGxDusvHzWAb7n4Kqe8ycToubJ1dbC0FAhrEq/
         IOliEGpFvZIfqK8su3xwhv8m73zubmDk/t9HH3NWo6OPdfjyx854isM17oW3wb/IOgq5
         05bYvZolzklTQATq3O33DMeJb3CD3cuDnKCuitbzltAJcIr8BVyLpLQgWw6nPI3rS0eu
         /zEy5B6wOvKvPgXNLPk8XPm08UwYrA/VUg59mDrJZ+q8Hu9RxyUZovTe2cCx3EOMnZYu
         qkZeMiPJ86n0RB00esjsAIYJ4ZGHxL3AIxLjUQm4mjfMzCE21G4iK3aqubZv+scZ153F
         Ismg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781208007; x=1781812807;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+DZhnLtU4hkHNEj9D5IMZ233IFNNjbtecRnYLHLtb/s=;
        b=OclQ8nsb6AKq301/sg2k9BIKsgwkWATg80F8eH+bT8lmDOqhZq+1+93y2oyi53tCaB
         rgnVSi2Hqs8ki9GtJcYoh/auivesC3Zr8uJ0BbB60JABv7yNvOdZdL95Bog2jWrWiDB0
         dIfcc8tsETHCuObIGBS66LNgxigRcbwzDniAkJ6Xc8jDlUZ59NTyLyJ/QzgjeAJotLSe
         G+4LtJu/VMve2nv+ikskUngtEfBhqsTjey7P0AhEL3tWFtTB40Q9TLtw3Jy6m8xXwyk9
         V+MIFRoJJviwAlEQUXB8MpG9ZZG+czDp+JfAdDO5Hyc4+sXxYURrbVNPV1TKPezmtTY8
         8lLA==
X-Forwarded-Encrypted: i=1; AFNElJ+jXxz0O2jUttZt8GO5Ufx7cfro7hwyKdYMs/2ZQ2JZwNme/e3g6yAwI1KRIWXut7TIoYZ6pnwXRQ==@kvack.org
X-Gm-Message-State: AOJu0YwwkDfruq6XSIxSKVCi0v9dUJH9HNUNotgb/1ZQ6GmaaW3upUSP
	3WEg2ehB8m+rbwwr2hSvUaiKSugRGpb2TR2FFP9rueyw2GPucP0HL5uhGpTr3/H4FIp0qIWgGd8
	0oIB8pYt+3aCso0AhXdtLplUHJ5qA154dbqP5j3Pf
X-Gm-Gg: Acq92OELU7DtgtYS8ORJc/mu2kHb0ipyJ7ZTM2zYxpARLH2NASjiOITkO8C842HXxVc
	afvlDCj82GDOdl/w5ygTTDmmNqZzen9YVrgbJFeSf8Gxr2OUggZwaW4/83k3G/lEYxhKUKCvyhd
	Ns9bBe4zC5HzcWjV8bb1GorrGHxqv+mce3H8kl6vMIIVZ4iNcas30Zv1gdYYfawuC/3MYfT6Kb0
	zKDZSE7b8Hv8/6ZdqsDYScXHeEHpvTwg9V12+WIJ3F68EJb/dkUQvIiUlnobtBN/ex2UFJIK9DC
	BQIiBRmZLwgTUjpre5m57al3KkbdrkPpADXo
X-Received: by 2002:ac8:5c84:0:b0:516:4f62:85ee with SMTP id
 d75a77b69052e-517fc539337mr136551cf.19.1781208006277; Thu, 11 Jun 2026
 13:00:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
 <20260610230413.D68967BC@davehans-spike.ostc.intel.com> <aipphZ5iCnbXVNSR@google.com>
In-Reply-To: <aipphZ5iCnbXVNSR@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 11 Jun 2026 12:59:54 -0700
X-Gm-Features: AVVi8CfiycZWPLAG7ErSZzCpvKT0WKpbhzlOg1vhjFlK_wz3B5LNBv38FT83m08
Message-ID: <CAJuCfpHmem_g7mEoic7O56LVSLkbftgWYgzexPWy7VSwp7_SiA@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] binder: Make shrinker rely solely on per-VMA lock
To: Alice Ryhl <aliceryhl@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, 
	Carlos Llamas <cmllamas@google.com>, Christian Brauner <christian@brauner.io>, 
	David Ahern <dsahern@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Todd Kjos <tkjos@android.com>, 
	Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0B4F9C0003
X-Stat-Signature: npcmwyuku8bxi8wacmy83hdrw1hxw7ug
X-HE-Tag: 1781208007-383443
X-HE-Meta: U2FsdGVkX1809RTaI4fzPv7p5P7bbCYTDI4bSAK4qKyIgB+jDt6DG9VzZYPbvrZihwIYFwqlvS/rGntibuZm8fk4k35b92XcUR2hL6Sy3pnaN9FNGBaCCZnu71w567pPsY1VMw/1dUh1OcEKX+ZkzUj42nfLnIhltvzcE3vTwMWzShMmZHJ+VYx8WeBaXOJXkgP8vkotvXCugSml0yGQNOCcexvW3S0Kl7sJRgs4ftyUHRaygi+7/poRsrN8vJrtk/1IgJg6jb2bby9GeaRXXIV9v3N0fAFdDa7s5Hbf6jGre4eXGwSuRSIo/+gK/KlAE2Glczj/BSypQCmQ0wB1B32RM3txFQajs1X1au1pD5xuJri/JbT1RlO2u9/28nV86VqnV8jRaFr0opnA88s37SWx4fu4hY/a8ctVEib39Vb47mhSZ7N9yOybNxXb4FB2NuVAQRBtrCqgxZ9N4gaIVk3bniReXk5WRp+TIf9OESS7BgC+xFDCIoeZ0clqQODhNNTHmaEIICk+W/l9g1wdhGNv3KnVM79EHIrKL2jF2jFeH+tFrNAfaJjjqDLrMt/m2m10BlNdXIm/cG+2PLf9xh7BEc2FkWvvv4SYat3IxQAFFI86bSqcl5OKhT1xGIlQLdrlczlYLChhkC1dzxzTKmGf/MMW9BgCpzUhskzXk+bM+XRqAD2OaHk6MST3VxSeG4WRMO9wzLWVPGcBPZJvXksL9B8lqs1yXDf/L80T0bv6+CkBlSxEeQnvr4aeDIzJMiVvUEy5OPmyG8E6mCBHZyXowo6Zd1+UjLA6LoEqairCTo1s8QSvMVvL92z86dodEjTV4rSLrhiDzQQ578psu7rvcXxpHPU77dANigWBAgO4KfcXTTqKKmP+n+UN44KEHSKRwYdZT1coNbZ7kiQG7JN9FbfnAcGX3zT/3hB715iI8025CWcxZDEvL6oXmZbz9ZTbO0C6QOcqmSmTzGM
 UNYeomII
 V1FYYK37t/563ZIxzxph+b6sZmrtSwy//U5aAn9N0v+aIcdOhceoCq2xKluDaCMe4ikusky30mTlTHBzgKpdhF3s8D1Czfij9OhReglTzsG2fkQ9oHih16SZdOb8buw/X8rKfbcthciDx8VZO317FZRjleIixT6WgltLIAWwHmC/N7ukeo1YEIgGRWocbHcO0kK2MjzjAwCq8lxHh/bR/isE6tWTnF7kgj4LdwB7QEgf1tVX3ARXTvVpjDtagXJlUnztpp25ZPJDYfUEsNXOZME0YkJosUTWrHbdrGIXr/qRAPrAHHPOu5wMaeFbaIXkt7Prnpvj+0L2epBd9Ph5QsvMn3I1n/0IcoOC1PTNv4Ru8reQFHUfzF/hj5c/qS689ilFBWDF3z9xMRumvA7YICFXclJ2Lly7vneO8ooY8UIMip/Dem2PwsYFETEN1WCxfuofjEvtyr5PJEwvX+tXhR9EgsEw2LSt0+NLEG7FjTMo5dVQRQkd2T7d9NZvUYJ9PNm7PPbp3rdbzVCjU2E+drWpDWglCmyJslQtcvV4/6DI2h+9xhpMJkCpAJI/QRGMM7W1qSk1RKdMBWYE75nIjSzN5Mg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 12:53=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> =
wrote:
>
> On Wed, Jun 10, 2026 at 04:04:13PM -0700, Dave Hansen wrote:
> >
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> >
> > tl;dr: lock_vma_under_rcu() is already a trylock. No need to do both
> > it and mmap_read_trylock().
> >
> > Long Version:
> >
> > =3D=3D Background =3D=3D
> >
> > Historically, binder used an mmap_read_trylock() in its shrinker code.
> > This ensures that reclaim is not blocked on an mmap_lock. Commit
> > 95bc2d4a9020 ("binder: use per-vma lock in page reclaiming") added
> > support for the per-VMA lock, but left mmap_read_trylock() as a
> > fallback.
> >
> > This was presumably because the per-VMA locking can fail for several
> > reasons and most (all?) lock_vma_under_rcu() callers have a fallback
> > to mmap_read_trylock().
> >
> > =3D=3D Problem =3D=3D
> >
> > The fallback is not worth the complexity here. lock_vma_under_rcu() is
> > essentially already a non-blocking trylock. The main reason it fails
> > is also the reason mmap_read_trylock() fails: something is holding
> > mmap_write_lock().
> >
> > The only remedy for a collision with mmap_write_lock() is to wait,
> > which this code can not do. So the "fallback" after
> > lock_vma_under_rcu() failure is not really a fallback: it is really
> > likely to just be retrying in vain. That retry in an of itself isn't
> > horrible. But it adds complexity.
> >
> > =3D=3D Solution =3D=3D
> >
> > Now that per-VMA locks are universally available, lock_vma_under_rcu()
> > will not persistently fail. Rely on it alone and simplify the code.
> >
> > Full disclosure: I originally tried to do this with
> > lock_vma_under_rcu_wait(), but it did not fit well with the mmap_lock
> > trylock semantics. Claude caught this in a review and suggested the
> > approach in this path. It seemed sane to me. So, Suggesed-by: Claude,
> > I guess.
> >
> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> > Acked-by: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > Cc: linux-mm@kvack.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
> > Cc: Todd Kjos <tkjos@android.com>
> > Cc: Christian Brauner <christian@brauner.io>
> > Cc: Carlos Llamas <cmllamas@google.com>
> > Cc: Alice Ryhl <aliceryhl@google.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: David Ahern <dsahern@kernel.org>
> > Cc: netdev@vger.kernel.org
> >
> > --
> >
> > Changes from v1:
> >  * Move forward even if 'vma' is NULL in binder_alloc_free_page().
> >    This can happen if the VMA is unmapped (Sashiko).
> >  * Rename goto label to be more accurate for new lock scheme
> >
> >
> > ---
>
> This seems to include the list of changes in the commit message instead
> of under the --- line.
>
> >  b/drivers/android/binder_alloc.c |   26 +++++++++-----------------
> >  1 file changed, 9 insertions(+), 17 deletions(-)
> >
> > diff -puN drivers/android/binder_alloc.c~binder-try-vma-lock drivers/an=
droid/binder_alloc.c
> > --- a/drivers/android/binder_alloc.c~binder-try-vma-lock      2026-06-1=
0 15:57:55.274412018 -0700
> > +++ b/drivers/android/binder_alloc.c  2026-06-10 15:57:55.277412124 -07=
00
> > @@ -1142,7 +1142,6 @@ enum lru_status binder_alloc_free_page(s
> >       struct vm_area_struct *vma;
> >       struct page *page_to_free;
> >       unsigned long page_addr;
> > -     int mm_locked =3D 0;
> >       size_t index;
> >
> >       if (!mmget_not_zero(mm))
> > @@ -1151,15 +1150,12 @@ enum lru_status binder_alloc_free_page(s
> >       index =3D mdata->page_index;
> >       page_addr =3D alloc->vm_start + index * PAGE_SIZE;
> >
> > -     /* attempt per-vma lock first */
> > +     /*
> > +      * Attempt per-vma lock. This is essentially a
> > +      * "trylock". It can fail even if the VMA exists
> > +      * for 'page_addr'.
> > +      */
> >       vma =3D lock_vma_under_rcu(mm, page_addr);
> > -     if (!vma) {
> > -             /* fall back to mmap_lock */
> > -             if (!mmap_read_trylock(mm))
> > -                     goto err_mmap_read_lock_failed;
> > -             mm_locked =3D 1;
> > -             vma =3D vma_lookup(mm, page_addr);
> > -     }
> >
> >       if (!mutex_trylock(&alloc->mutex))
> >               goto err_get_alloc_mutex_failed;
> > @@ -1188,13 +1184,11 @@ enum lru_status binder_alloc_free_page(s
> >               zap_vma_range(vma, page_addr, PAGE_SIZE);
> >
> >               trace_binder_unmap_user_end(alloc, index);
> > +
> > +             vma_end_read(vma);
> >       }
> >
> >       mutex_unlock(&alloc->mutex);
> > -     if (mm_locked)
> > -             mmap_read_unlock(mm);
> > -     else
> > -             vma_end_read(vma);
> >       mmput_async(mm);
> >       binder_free_page(page_to_free);
> >
> > @@ -1203,11 +1197,9 @@ enum lru_status binder_alloc_free_page(s
> >  err_invalid_vma:
> >       mutex_unlock(&alloc->mutex);
> >  err_get_alloc_mutex_failed:
> > -     if (mm_locked)
> > -             mmap_read_unlock(mm);
> > -     else
> > +     if (vma)
> >               vma_end_read(vma);
> > -err_mmap_read_lock_failed:
> > +err_vma_lock_failed:
> >       mmput_async(mm);
>
> If the vma lookup fails because the mmap write lock is held, but the vma
> actually exists (has not been unmapped), then this code might "successful=
ly"
> remove the page without invoking zap_vma_range(). This means that the
> page does not actually get freed and will just hang around forever until
> the process owning the vma exits or Binder needs this page and maps a
> new page on top of the page.

Yeah, I think if lock_vma_under_rcu() returns NULL you just need to
jump to err_mmap_read_lock_failed, like we currently do if
mmap_read_trylock() fails.

>
> Alice

