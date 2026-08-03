Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A5CCC55196
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 18:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 060336B007B; Mon,  3 Aug 2026 14:31:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 015E96B0088; Mon,  3 Aug 2026 14:31:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF35C6B008A; Mon,  3 Aug 2026 14:31:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9F2A56B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:31:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C5ACC07B6
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:31:29 +0000 (UTC)
X-FDA: 85060801098.24.11C2CA6
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 71F3CC0002
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:31:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cvXcUFTq;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785781887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2sh20aaLjGDr49LHpT4MIdFB8Gf/03Udd36UxUfpzRE=;
	b=NYCZit6RDFSY3nTI+VtCfq3FGC37Wcc3NZASu2ZTVxeQ2+ozh3o2zXeLS+ywqtkhNzk9Bq
	M8K/VAxjamcujlmDkcYTziq5rYnN/DzCr6bPx5Nbf0ecFrdKGJQdtBQReG+sD5z2coYURK
	TaH5dJJS1R1xF6y/udEu0AQMSVPYrt4=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cvXcUFTq;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785781887;
	b=L0zNbmWcR4XoDTOhwup4N14tMJEOVrCUjFFSKMc5gKG8wRmU2j/Yp6KutMjME3mKV5tXjn
	ZKY3mUz5vT+3jLkPiptQpHqpM6iYkWR4pHI76d4fN07aKw/kf3bYIUIO1UYEeS7z7yOGtO
	TlcNZStVLp5tNI7EH8pfTw8g2gtXrr8=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c10e86e52so36271cf.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 11:31:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785781886; cv=none;
        d=google.com; s=arc-20260327;
        b=WB77+RTVMDpIqH5+USsdWJimPxul9GG2GivaTJ6CNhXwWTgsaGK9S3X7o+iL4hvQ2l
         vGJyWKvELzcMlGHd2/NjSlwy/NRu38M55vrkzo0lerXvE+WzLtNHMo6exKQq20Mkpr/1
         FwZiW0OF58eU9drjKQk/19MYdrN/RL2liqZ0jck9/Vp5fftSUrbx/7D9e0fQl40cic8d
         X0iqH+4QOXEa2StOZek/Da9HIIFqxEYXr9o74xVgGMZqzf928waCGWbEX1lpCdvtvC4x
         crCW4WYVx4U5awRQ5V1sF41fTdwKb5BbOk5Vu+JS711yMNDmXi310Fd+Ky1ip9SnlX0m
         /9Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2sh20aaLjGDr49LHpT4MIdFB8Gf/03Udd36UxUfpzRE=;
        fh=6dPF0rHY1A4KlO2FmINeLgn9JeOejO3liQfRP1DkHgY=;
        b=Q2AjmhVVX4g1+L4UlmRrjGXyvO9IUkI1wT5JOa0uwEnTzKOBIdTN4gZttzz2clZdJn
         MdledcPnniSMIksHLv5SinMebAm8bZovGf7CBO4cS/HUVs41yRWxyDITVXaiX5tFAxBW
         jsOdxlpwd8VszCZF3QhepVTz0f8EYOWnZmUfaUGcT50jOEmPhBwbBZbxddjOKzbd34yp
         T/b9kPJJ17DGS66pmCPlZPtVmuRUia8qli0xqy5oLk91j8M3vF0jwt9T8anM/NzReBg3
         UXr/S1EF0ms4iTxUBXsVNVPRho7Ral0/J+c9CyE4nPFlRSkWajjdIGCRMwCRM2O027vn
         jf1w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785781886; x=1786386686; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2sh20aaLjGDr49LHpT4MIdFB8Gf/03Udd36UxUfpzRE=;
        b=cvXcUFTqbh6T/5yM0eEMVsmuWqFjUZMjlc6KEilh9L6rPKdl9JGFw0e4wep9OrfmeI
         3j3+m/ODcYMIlAkdjKarqAInD/B8ts1sOfMlo2nlHZ84D0k/kS0EJprbDXtFdDCSsIgE
         Oi7I/EreUqbr3w1JSSEugfrtL+yQEaAc7YxMIUEiG9jOXhwNblZVD0R3yY9G54gAoNKF
         OUK/lgHK1MqCbIQT8z8XqOd2WlUngGzb3nBrclTrdEkpKhLyqiPVXk7Iq6oPaggapRVf
         0Yu+Ueh8f/3750L5oP5rc/Mv/ecJK5l4jy6X493kTdeRRAvJGWrdRuTQBrrutzXEW64i
         C0lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785781886; x=1786386686;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2sh20aaLjGDr49LHpT4MIdFB8Gf/03Udd36UxUfpzRE=;
        b=c0YVHGmNK+jm6FCwo4t6SGjO47/YgFXvQMGcbf//fIbQyct2MtTx955Alt2BfAO26S
         8iV2dg6eaSYFhZ/I6kVXpysn6CmReVi3pzN87A0RzwcbqiHRamhTXogcHwPvkl42J4a2
         49EnSTr+JpbxQxC0J9uNlhkwXz2EO/ELR7jDESYuVQICIezKR1pAFHnqwgCbe9tDe8qW
         96LQHkoQ1XMa0++mzz31ljondrxB6YNuKNeZDz//H7Ge4CUIUo9lZ/CqNy5t11CrHitO
         BluOt6VWoFH/sZGT9+GpoybHW99ZPMJ8otoySpdlMPuDcsx77gw6z2qdXk5s7w9a0bpL
         bwTA==
X-Forwarded-Encrypted: i=1; AHgh+Rqz6gPv3o9SJkKr3BGZoJkhz2w8G/nQHKhOrt1EDUXRR4cWwfvoKwoxQKOfDRNPZeuEG14OBILmqw==@kvack.org
X-Gm-Message-State: AOJu0Yy4hFE9jCklKEbb659rXVbHOhztYdqUCFGK8LKJ43oV1QCscfFH
	oKBjteEwVzsMo8H3X+7tYRABr4AoZTCfTQcRFayNqXNIcAGf16F2xXojqJRXknL8+ovEhTuRdfm
	bslh36BvcY2aVYNbaMW35lo0o4t1teKT9pIF2h9Wz
X-Gm-Gg: AR+sD10bI1opcprFzhXmxBM1YTfP6BK+cT20BL2ZQlDPJLlXCsxIwnfVxLHuBRmmKKq
	qROfB2M/FraDdEdb+Ve76miO/KCztPUk6xV+eGVtW/DzsOSu0RKhT98kIyeos3/h0fP5p8Rvz+4
	DNLx6ApFVYl7pHw3wQfGi5d6ERtfAJW968NSuYotqOX51+L/iS2u2HItVIAtoXGkaue6zdJYH3d
	/L9CH+/jtaIbcnQQT2LJcRMZ4Hv/doysbWnbc3iak2meCfeHvoa1kLSByO/HavLS71H0PA+em14
	UvjOCXZS3YplqRzqizMQhIqer0Ahi1Ln5le5HYoQuOJvtKmcZW0shY8=
X-Received: by 2002:a05:622a:9013:b0:527:f08f:56a2 with SMTP id
 d75a77b69052e-52cd4e7dbedmr1574331cf.8.1785781885821; Mon, 03 Aug 2026
 11:31:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260802215459.2769283-1-surenb@google.com> <20260802215459.2769283-3-surenb@google.com>
 <anByp6uVW77uofKx@lucifer>
In-Reply-To: <anByp6uVW77uofKx@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 3 Aug 2026 11:31:14 -0700
X-Gm-Features: AUfX_myBOeiNVA0m1qVZE2GBbWEi5bWqHPnmKZfxbZ2vvxGu8qUxd_oIiqOluMk
Message-ID: <CAJuCfpHPcE0=7825xiusBN0MmCp1hrnsDuYrfTKwGM43ozmmOQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] binder: Make shrinker rely solely on per-VMA lock
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, david@redhat.com, willy@infradead.org, 
	shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com, 
	aliceryhl@google.com, arve@android.com, cmllamas@google.com, 
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 71F3CC0002
X-Rspam-User: 
X-Stat-Signature: 3x78c53zzmf7zm79cu9xufjh18raz9ou
X-HE-Tag: 1785781887-467613
X-HE-Meta: U2FsdGVkX1/FYTpZZ+J1/KtFARAyw/yW99N6INWjl9JBFJQaZhWG8aQEfFs7CmOaEbHEVN4UhXQaUzowQ68yHvFxGcQdZRxsrh60Z4pPavle2cGATPpc5e6o2EPZgPh69NlyIuUCw7ICbgHpeyHI0B5eE71tajwF0V2DT5qY6oLgNPhKGtLqnWJISUONOLpHaZP58vhb98Ji3AhNOH8rC6tR6TdYxrouqfWxkykZRl+TI9W9mXgS4iEVyrpqbl0jZQDBnrlpW2mco+q1vvCcT2zG7WaGpONOaAxXW8r6eG5sb7GTTye9h8Gght5I5Zu0dNS6pbAee0KvgihxJ2R7+c2+ZlVlaPHBEZ1uGzIolyr42P16c4y6Ozm2EvaLjQFtFv8rl+t7Zr7djA0PisxF8+Rrh3fYLmZWtg+gu3F8zoQIEx+N4NxQyPBPzmEG+GNYBi7iPjdvSWjSpnH+6Dck+KRdpxj2dVFsF0m4bRi2gIba+vtNxUSUoGdCqh7zhd650eCbaGgzSRQoZlLDz9oPA/tX75x5WPXLl+kxgSCMLlKcf/NSbjgzyZTxD3dBgSk5eKKZ3yimEf+/ksWGudrash2WvBS0atimBRKi+ysjlc4xtZqFzv8F7CpVW16ym3anGenyvdnHHSaqUW+iG3PJUSh/QHprgc95dWGak46ttj0KMurXau3SwToCDr2APxuGrlpeo/mf3ufxxpj5hdDVWJrDUzSWdD3EWPLJqcZONB/kN5xgVfbzwNMjUtX57MvHYD4jXQgD9Z0dqg3CtsFpzIphrjVNCAS11NFad/p11pcPLrfdSeflGcePGyXDCPqkJGLzj8Q3IIokkKCYQWDGrUM0YCn3A/jjrtCtW4FF/3oELsc6wHL+MI/F6pZBZSVFJeKlbjmppdvSw3y6LOKZuQ1K/rbCxM1gZhYiTH0wq7RRke2KxHNdJmK6Hm4sUuMeDddpyg6LNaTqbeAo9sz
 U1kS4pJk
 ucX1xQCBzoGIadiov0VKX8xEXleldnonUIsJEigDla7PIiyu8pxoMi4aRprlbgEPA1XLluCBbPVAENu0BVEAFlkgs+Lvt73+tHw42bmiHHqCpqKVlcK5/xWMHkn9Hma9wjN8XKrTxI+SksASyMlw5ohh83bxWTX4p9SXcDmW3hS2V0OggeCSBnwTLWFdq8x+/jEIVS5lkub/2w9drg4ZmNYFMNqMTCtzW1LvrtgPQp2hwrLqlR+AQ6nsV88tVXqlh2zkOKw3rM2KNBI+3GR5hwxu91S4qgPucH1kgcV33pIaVIrbKxtqVJW430Hzk4QmRf1JDUK8auomOk+wxxcZdIlQDFqd6Vd18yJN/59c2l1ARrodWRqX0op6U3dGyOBXajxGtlwwnFfKvtpVKEkRGAXFKtsWFjktnXz3akIL4S9fM6gxNX8ObWBUhlni961d8bl+lWTNMJAfqesw110M4nRKoRDKy83oWy/Dtf0+yWHF+7ddN+fZwzrRnr1lpw8vtj3n7cClieRx1E/Chk6DUdiQX2UbqEeKxZ43nu3sGtY1+6a9NZJeTZI5uhv/00WzUY80Bzhg+kENzCgnVFMopw+LdnoD4FA2O7GbwvZ2l7Tf+tBWcJMxBdNHw8bSyKFsUI9jJxRysFhMiGqgMj8n/uf7d4NICCFqRxRTf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 3, 2026 at 4:10=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> On Sun, Aug 02, 2026 at 02:54:56PM -0700, Suren Baghdasaryan wrote:
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
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
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
> > ---
> >  drivers/android/binder_alloc.c | 29 +++++++++++++++--------------
> >  1 file changed, 15 insertions(+), 14 deletions(-)
> >
> > diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_al=
loc.c
> > index e4488ad86a65..84104ba04e30 100644
> > --- a/drivers/android/binder_alloc.c
> > +++ b/drivers/android/binder_alloc.c
> > @@ -1142,7 +1142,6 @@ enum lru_status binder_alloc_free_page(struct lis=
t_head *item,
> >       struct vm_area_struct *vma;
> >       struct page *page_to_free;
> >       unsigned long page_addr;
> > -     int mm_locked =3D 0;
> >       size_t index;
> >
> >       if (!mmget_not_zero(mm))
> > @@ -1151,14 +1150,20 @@ enum lru_status binder_alloc_free_page(struct l=
ist_head *item,
> >       index =3D mdata->page_index;
> >       page_addr =3D alloc->vm_start + index * PAGE_SIZE;
> >
> > -     /* attempt per-vma lock first */
> > +     /*
> > +      * Attempt per-vma lock. This is essentially a
> > +      * "trylock". It can fail even if the VMA exists
> > +      * for 'page_addr'.
> > +      */
>
> This makes me wonder whether lock_vma_under_rcu() should really become
> vma_trylock() at some point in time? :)
>
> Or at least have 'trylock' in the name.

Makes sense. I think I'll postpone renames until after the series are
merged. Don't want to mix too many changes together.

>
> >       vma =3D lock_vma_under_rcu(mm, page_addr);
> >       if (!vma) {
> > -             /* fall back to mmap_lock */
> > -             if (!mmap_read_trylock(mm))
> > -                     goto err_mmap_read_lock_failed;
> > -             mm_locked =3D 1;
> > -             vma =3D vma_lookup(mm, page_addr);
> > +             /*
> > +              * If the vma exists, we can't continue because we cannot
> > +              * remove the page from the vma. However, if the vma was
> > +              * unmapped, it's okay to continue.
> > +              */
> > +             if (binder_alloc_is_mapped(alloc))
> > +                     goto err_vma_lock_failed;
>
> Hmm, it seems a bit odd to me that you also have:
>
>         if (vma && !binder_alloc_is_mapped(alloc))
>                 goto err_invalid_vma;
>
> Below?
>
> So you have:
>
> Before:
>
>                                 |binder_alloc_is_mapped()?
>                                 |yes    no
>                         --------|-----------------
>         vma is mapped?  yes     |OK     abort
>                         no      |OK     OK
>
> Now:
>
>                                 |binder_alloc_is_mapped()?
>                                 |yes    no
>                         --------|-----------------
>         vma is mapped? maybe    |abort  OK
>                         yes     |OK     abort
>                         no      |OK     OK
>
> The 'maybe' is because the VMA trylock failed.

The case you are considering is lock_vma_under_rcu() failed for some
reason other than lock contention (say seqno overflow). In that case
we get vma=3D=3DNULL and binder_alloc_is_mapped() is called without any
lock (VMA or mmap lock) being held. I'm not sure if this is a real
problem since I see other places calling binder_alloc_is_mapped()
without locking. Alice, Carlos, is this a problem?

>
> So the issue is you might have a case where the VMA _is_ mapped but
> !binder_alloc_is_mapped(), which previously aborted because of the vma &&
> !binder_alloc_is_mapped() check.
>
> It seems like:
>
>         /*
>          * Since a binder_alloc can only be mapped once, we ensure
>          * the vma corresponds to this mapping by checking whether
>          * the binder_alloc is still mapped.
>          */
>         if (vma && !binder_alloc_is_mapped(alloc))
>                 goto err_invalid_vma;
>
> Is testing for a specific scenario 'we found a VMA but it turns out it's
> invalid' and aborting if so.
>
> So either this check should be removed or you should uncondtionally abort=
 if
> !vma I think?

I think this check is fine because it basically checks
binder_alloc_is_mapped() after stabilizing the address range.
Unconditionally aborting if !vma would prevent us from freeing the
page if the VMA was already unmapped. The ultimate question is whether
we can rely on binder_alloc_is_mapped() alone when freeing that page.
IOW, VMA might still be in the VMA tree but
binder_alloc_is_mapped()=3D=3Dfalse, can we free the page?

>
>
> >       }
> >
> >       if (!mutex_trylock(&alloc->mutex))
> > @@ -1191,9 +1196,7 @@ enum lru_status binder_alloc_free_page(struct lis=
t_head *item,
> >       }
> >
> >       mutex_unlock(&alloc->mutex);
> > -     if (mm_locked)
> > -             mmap_read_unlock(mm);
> > -     else
> > +     if (vma)
> >               vma_end_read(vma);
> >       mmput_async(mm);
> >       binder_free_page(page_to_free);
> > @@ -1203,11 +1206,9 @@ enum lru_status binder_alloc_free_page(struct li=
st_head *item,
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
> >  err_mmget:
> >       return LRU_SKIP;
> > --
> > 2.55.0.508.g3f0d502094-goog
> >
>
> --
> Cheers, Lorenzo

