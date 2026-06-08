Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0308CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 15:43:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65CE26B0092; Mon,  8 Jun 2026 11:43:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 634346B0093; Mon,  8 Jun 2026 11:43:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54AE06B0095; Mon,  8 Jun 2026 11:43:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 45E896B0092
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:43:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC92E1C0823
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:43:28 +0000 (UTC)
X-FDA: 84857164896.15.D862EC5
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf28.hostedemail.com (Postfix) with ESMTP id EC591C000A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:43:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uXm9z2Ly;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780933407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ImVZHEvL5DaiMqGQQ7oF61NPY2ecFeN6e1eaZ4yGJGU=;
	b=oJeXukgsCMtLN6V2i9kCOHq18KP/zEbaGnnHCWcFslBoRCWX80LPNouZv2VxnsqIZrF8Nm
	boEWIxL86sW25TlSUa4IcAExIUNYMxnr0shu1ai+cxCED2ru1nUHrmsouD9XBlOO+EGR7H
	nGxqvbYCv2Em1tLB4OaiL2gGYzdt6c8=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uXm9z2Ly;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780933407;
	b=CbQZyHdagg6a50WOmIrJ8j6nfkiFFCUxerPO91ECHgfc4EhEb01DI5UeoFaU4grrslRTm7
	KEHod3WV1fMRyYBTrK+B4/eZ0kvb3xIZLvge+OIdafyQLr+1ZNb3I4/C/xhv6Sy7hps+EN
	hGFKCoepPggNaeC5LaF3WZ6zTSTMXsI=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-68ced08613aso30486a12.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 08:43:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780933405; cv=none;
        d=google.com; s=arc-20240605;
        b=WTKeCj7QzLcR6ag2SvEaIjiF9ti1cOT2kX3ALxz10MXBbh7NH+3gOsnW3kO0X/y8uu
         a8Ig/GViA8ofuqE8cMs+l8FTtl/AUWlJwhATAxmvBJ3+Snjx+LPDQs451TR6mOSS93im
         CT6pVIMXlWYes7usZx4fOpJIq4PzmSKElTxGOokRggGSmt5uShzna4LqtISCQ6k81l4q
         RYrruhtGVUwR6+zX9t28BgUqqeknigv0GVavxSM+wASDjVFN6QRZWBu5QNqSHp/25l6/
         B8XMcBlAPxD1jG+DZlgtEzjVlZqr6jaszyFWDH6grZu6qv7/pFzyldpdsfg9Z0lQvF5H
         6trA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ImVZHEvL5DaiMqGQQ7oF61NPY2ecFeN6e1eaZ4yGJGU=;
        fh=XcAyFPbzYRZ8mg4NBYhaq9Bi9yUCYVMH8POHJ9JK1so=;
        b=Xe8BEnhMewGBEkfu5fTXulLco4Hm/2nkijc6Y/srHWWz23jJgUAHOHiDjAnhCvZYzk
         e6yzkioDMT1NcXao55hp5ApBLxJHrFzdkmH+RczE8UVE6eC33qlzF9lQJslB2s9q/XFf
         n7NLO/nK2YkIB7UDc2lwNuBSzdmZj/L8tZ8PHMHK76oILW1jKqDIHaxuxxh4IxQote0z
         eBF9jtBKnoVY5xrsYDOoDvhGp2CF73yqYHkpvn2oPG1TN1OlJEiA4ZsrzqRs13fHUfv9
         cz8kz9Yu4t53gfQPA8YwjZZUSc9RDZcjjJK3X8nY9w0hOsTh0iO8xGv4zgG9foSlgnbe
         sk5g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780933405; x=1781538205; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ImVZHEvL5DaiMqGQQ7oF61NPY2ecFeN6e1eaZ4yGJGU=;
        b=uXm9z2LyKWLD2v08dhpc3MqlKhJ53UBHCfmWLmAL560MNR1BTBGU/cSYhT7NpR9RD3
         g0e5H+rZnZ3Et9HGdVsnRBqH/NrCHCSR0cB/+/4KbKhUdF3gBr8GVS+QCJa+cEBzFwv8
         5392WSQhb9w8GnAmrmpBe1BdkhiYCanRuDBZvRwLdUFjjremIFA58UEtb1+sA3tigzFQ
         K4zPbZAvPY9SyeuSLOs2jfLK6dEAMccEUqGNFmsddewzkDid0PtYhM/fpUVYznjSxCYX
         ngvSrX6SU6XLCGiyk5Appf1wQQvD4q2m+ZnzJ39K+SUrz6rlHLZJxkdLxu1SvK/mEZSt
         Mw/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780933405; x=1781538205;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ImVZHEvL5DaiMqGQQ7oF61NPY2ecFeN6e1eaZ4yGJGU=;
        b=XyDCNSC9StiyvGYKjPmqkl6KRolEa/drI408hLvzq4h//TYU5FKEdoLfuDlJYLjIyp
         ARWCQxFBSmp5LFfaKh7M53XL6P6kruTdMaXfydiFm9Vow83ioTJFWKkB6ZpFUZzu+2Yx
         D7eidWSo8ONuQH/E1qbuobZyp1giNEhISzPqaiQlAD2xFpy8p4bg58z14tj8OGDx0Eib
         4jrrlCH71KmTgyd3R4Gqt69ZXvvT+SvZY2b1cZ3PE47Yo4bNwMoAZVuZu37hJehKiarc
         9Jm9Kj8/1BjC4SikEqXx8eu6lM8BSk0nkk8FqM/0IJne+NQPHm7ni/9CSslAZw8PrUSh
         M+tA==
X-Forwarded-Encrypted: i=1; AFNElJ86FzfQ3nSy96+8yMQfADF/INX8fIJMM4qbZ13rU53wupk7zsYxcIthgHvr2ETYqNOEl8EnjQ264g==@kvack.org
X-Gm-Message-State: AOJu0YzUY4+v7m9NGRsgIUnfd+1f9wxmsk6mqspEI5gxK++tsmSyoGjm
	byHrZ1i9enJDDM12+lAa9+erc17wXq0iz59y0Y68hqJNl6hzd36wBNwrdpUlsmjCFAMcl8TyylD
	oIc0o68KpJZ9TAbG9H8JUJsrio8SO0bxJJN8qxaSn
X-Gm-Gg: Acq92OEF6Sp+fCNRht7U4LwUSC2Nchq6zwOg4YfngxuS2IfIAm4mebxnZmmhWATAKeO
	qdPWu17JD8zZNgnpgqhioF3lCr/cUjzEYdYjTZY/yfaa5GeALNpOzZ3v6EB4/CFJQb9aCcgr0ZI
	529gYDtX9H30mqt6kHOVb8qxaXlzdD60YJi7scrWeyBILJSzg63RRp7GR/SkRwPJtEyspFpL5H5
	uwYJJbJaVOXKshr/4Urz4KoCu2uTNuIaeptqqsT3OS2zPcr9OKiWDyJuMR6D+ZxjF4nIupkTJr9
	GK8BFezm8agSCMZ6
X-Received: by 2002:a05:6402:4496:b0:68a:faa8:9564 with SMTP id
 4fb4d7f45d1cf-68fe9272c6cmr228481a12.9.1780933405006; Mon, 08 Jun 2026
 08:43:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260606015729.1837935-1-surenb@google.com> <fb25c5c3-c3b4-44df-acd6-46040ff1027b@kernel.org>
In-Reply-To: <fb25c5c3-c3b4-44df-acd6-46040ff1027b@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 8 Jun 2026 08:43:10 -0700
X-Gm-Features: AVVi8Cc_t40vlw66hgAT5JXUBBtCVUtxAuOHL_CbRtWc8V6kZ3a7TUKFsTPHnxQ
Message-ID: <CAJuCfpHbsAC+kw2B5m=TZv1CN7KCxCUVAcEoTKGSz3DvVUc_9A@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs/proc/task_mmu: change lock_vma_range() to return
 error code
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: tjph5mkfm6wst1doxyhycnao7t8ujwiy
X-Rspamd-Queue-Id: EC591C000A
X-HE-Tag: 1780933406-580354
X-HE-Meta: U2FsdGVkX1/SdrOrBb/cKpzRTjWTzbTYTSVvrzZXsOq87t7q/fccViPno/AOY9ejAUcrkttgRbSiALxlWVVuVj+UMhxvwZxvtJgyX3k5U2F+jnBfaeW56DHDJndtSjKL8wXaRPGvWoPfbAuDbW4k5RJ6AJ+Qliu/xsbvpphueXCvLJeOXzKabUq2u0Cgu2JnKTHcb5XS7oX22nhEO4dVkbAtTUWQx8mkOFicoIbJi7zDQHaoMCyDGT86dIAPOu3PiWE2wxfkLVqmxqQ4Ivivcy1a9VTBcu3heETAFBDCGDsFFDFeV5XXJ3xLv68Ln496iniy2Lp/Mmq36zNpdOwSnw1N6qzZRDaZqaFSoDlyBKQt5zGxoYKxPGHtlBX2SvsZTSDRM6f+a79CpJyvC+GhIW9KLLVcT9HCG0XmORixUhkP7KsZLkUDo7JJvvr6ewc4em9YJ6f2oQ/6t/NUEWQkrJok4AiwKZm8nPakXat/t4IA/vPvxzP2qzTS1QukBYr5EdULIpEZJYEfplAtNtaJU5Vu+FgkxUAGf5Cu4erPMyXDbYHDbW7wtYj+lOOETuHbA5V5KKA+Mkgqr0GNUZeKcJLEOQ0If8S4cIawI5zoGdNn5YWgRXIUfuiiy+ek4KiVISSyjHJju9mlSk1OF3hFmxXwojYAAZo6yOkGfsAy3V8sEgiYDN6JfjihmlSscj78ktpqXUC0xPw4SE89lNrixF9lxoXOZtQ4sjwfz8RugU+UKeDInQn8vak4xR+sXQ/rebVGJE4B7LSUtS3ippiNrzNEvR2q7s4M1lVJHYB/ZTPwsLuyZnnClOeBaDwIWSriNcDGQWODD45qTiyF5PZRPwQ+wfr9iZieRcaNNGxzST4ITfCneTlfN1lQd+X/AqCmslavCIGP8Hzyr3RfTEyRvlb8kJKcDJlH6iwqEyS3q43Z3bA9Y7pZLHKupO3Rat5YE8HJg5zFBJKpCD/Y9Ma
 79LbB/hH
 WNfiaSN8vrgewIh/CGlmc86zGipnwGIwqW1Xegj/9zcA+nojXpbSUNUwyzOkMIReIkVGI5T+VMXsP5TqnSofxbWj41Bkhqh7keks3msPSC2x1nBDYPdyD6zCIRaGNEXBu/tCOUCj8vfRWcJtES4ErJkDS5GHIAmLWhcmaeTE4ekzUyjH+LU2uHQy1mDRK5SiNDzsfVrkB7Ztin/qCWx3KeRHxOEF8UICj1smSJzaaX7jQxHXybroqTQVj1r/qc6+CCbjSKULM8fDMv1Yg2HpAZpA7KyjYIG0A9KnOdJN5FeWtZmuhRTBtfWIbCMDVT4eaSy7MU9P4a8ylcxY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 8, 2026 at 8:38=E2=80=AFAM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 6/6/26 03:57, Suren Baghdasaryan wrote:
> > To correctly propagate error code from lock_vma_range(), change it to
> > return the error code instead of the boolean. This simplifies error
> > propagation code.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  fs/proc/task_mmu.c | 16 +++++++++-------
> >  1 file changed, 9 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index d32408f7cd5e..023422fcee12 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -162,13 +162,13 @@ static void unlock_ctx_vma(struct proc_maps_locki=
ng_ctx *lock_ctx)
> >       }
> >  }
> >
> > -static inline bool lock_vma_range(struct seq_file *m,
> > -                               struct proc_maps_locking_ctx *lock_ctx)
> > +static inline int lock_vma_range(struct seq_file *m,
> > +                              struct proc_maps_locking_ctx *lock_ctx)
> >  {
> >       rcu_read_lock();
> >       reset_lock_ctx(lock_ctx);
> >
> > -     return true;
> > +     return 0;
> >  }
> >
> >  static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock=
_ctx)
> > @@ -245,10 +245,10 @@ static inline void unlock_ctx_mm(struct proc_maps=
_locking_ctx *lock_ctx)
> >       mmap_read_unlock(lock_ctx->mm);
> >  }
> >
> > -static inline bool lock_vma_range(struct seq_file *m,
> > +static inline int lock_vma_range(struct seq_file *m,
> >                                 struct proc_maps_locking_ctx *lock_ctx)
> >  {
> > -     return lock_ctx_mm(lock_ctx) =3D=3D 0;
> > +     return lock_ctx_mm(lock_ctx);
> >  }
> >
> >  static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock=
_ctx)
> > @@ -311,6 +311,7 @@ static void *m_start(struct seq_file *m, loff_t *pp=
os)
> >       struct proc_maps_locking_ctx *lock_ctx;
> >       loff_t last_addr =3D *ppos;
> >       struct mm_struct *mm;
> > +     int err;
> >
> >       /* See m_next(). Zero at the start or after lseek. */
> >       if (last_addr =3D=3D SENTINEL_VMA_END)
> > @@ -328,11 +329,12 @@ static void *m_start(struct seq_file *m, loff_t *=
ppos)
> >               return NULL;
> >       }
> >
> > -     if (!lock_vma_range(m, lock_ctx)) {
> > +     err =3D lock_vma_range(m, lock_ctx);
> > +     if (err) {
> >               mmput(mm);
> >               put_task_struct(priv->task);
> >               priv->task =3D NULL;
> > -             return ERR_PTR(-EINTR);
> > +             return ERR_PTR(err);
>
> Looks good: down_read_killable() would also have returned -EINTR.

Yes. I also use lock_vma_range() in the next patch and this change
makes the code a bit more cleaner.

>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

>
> --
> Cheers,
>
> David

