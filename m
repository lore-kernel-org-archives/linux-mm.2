Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA64AC5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:55:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9396B6B00FF; Tue,  4 Aug 2026 10:55:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90FD96B0101; Tue,  4 Aug 2026 10:55:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 826236B0103; Tue,  4 Aug 2026 10:55:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 52C096B00FF
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:55:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C29721601C5
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:55:03 +0000 (UTC)
X-FDA: 85063884486.27.3469F1F
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf11.hostedemail.com (Postfix) with ESMTP id CBAF240008
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:55:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="vJbmhHt/";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785855301;
	b=GUEGki9GWqIPs3MhwBN488VoUHoBw5QvlwCnWk/GLH6QqfH9f2ePkDKuTeKyG+IMXVVhWA
	AIuzte+PAAUO2N69xOQ21eppUka3hm+exTclUNOfIgu4zavOqwBQgZEPotslFcdsMt+/Hm
	7pCG59/Hvv+qvsD1Ri4c9Vq7eoQx6vs=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="vJbmhHt/";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785855301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v05uFFs4hQG6LmTfuKA4XeVgXPR5RZeVv3+eUBjSWnk=;
	b=BZ+doWaNW00DQMzAWI8hZ+m8KCAHCz0BKRKaWvEQflSxAzTaUmyq5c+miWuEfDa2uyxewl
	s9f0evDR/ZEIiIwyiM/Ka0DkwLVoY/JVICvHtrUsJSw9SgPiXczz/FHAg/DGFrFypZaHAq
	tJILbRZUL3HVTzAnJXKFod/ZMB91I+E=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51c10ed63c0so263301cf.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 07:55:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785855301; cv=none;
        d=google.com; s=arc-20260327;
        b=PQLfHISyU5GBIg/t+LGYnKDYUneyCV9FC0sCGJXZT7ufCEP3fArqOTb3zfzPqLGSs+
         xlCGrJuFYZQ9WcygUZQeHh/0PkYAsXyeiCaFaeeTy7DDZdHIm8E5WCKpWKVd+2ldQPrE
         wvNKWLFZy7QTnSwZ+YmqhYN4ZgmGWFdzVQsh3jaXb3hqCNXl6x+nbzOouXNGVO3XfgRc
         FZ7rDexyl+AQCCF5nrsezCmfEg+WSf6/iOKP69Gz5O3Z67UWMu31odztxEnMqK6rFDlA
         X+Z/FPnOBgwEZ4Dno4GhFOIlgMI6z+Nkze/l5NlZJyyrh5AIAboIyr099+DYW3FxIkdT
         lEMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=v05uFFs4hQG6LmTfuKA4XeVgXPR5RZeVv3+eUBjSWnk=;
        fh=VvLDsOyqiqTCaD2NXPP3TZfA84kIwoFPuoMkydrjMZ8=;
        b=gmHMNhyURyw4R154wC/HbEMIn/gMGe6xyQ+UmLz6fggrNa7+sBjOILL9zHH7thj8KV
         ea2BHM483aTmx+azaZCt2zQnt71jwYjNOO7UfyyaOkgYKEM2jksqjPZ7JWJBjrZ7VZsE
         yfLNpB74D4BZUV9oDnb3tMuUqStLcPJWAq6YgU6KOJSwJp3HTWwdfLUQ2mhvxHXStfDa
         otyAVH1v9PVekvoyNX5KvU1PT5eZhE78+yzgCA9xvpm9zagDIHmQhT4uEz+YRWu5HC7e
         xGgIvczs0PBSZ4gLOAte8gI6HoQ2bQxiDnv7GLKezJdD5V2YHGUMLF+mClt0HvjHtKcx
         cNiA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785855301; x=1786460101; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=v05uFFs4hQG6LmTfuKA4XeVgXPR5RZeVv3+eUBjSWnk=;
        b=vJbmhHt/CZnhdL2f08DyBr+vN1yHYNRg+lWZ5wS6k26cpkO6Dyky/g7VQ+2AkBYggn
         3cFtj0tlBMxFzsJ20Jcc3ehFEYO8uAvR87LStk521f/nNVIyUuShe2ZX8BZ3Q/N7nDYP
         fi5dLTBhFDnixufzKvGRaYHU3cIDzKWnyBvfIRT2w7YKs2gEZyMx+UZAaHmwmKM6AIZk
         2I7A3ZE0e+JmAQGfd9R6pWNifGRDt4NO05Ft9pb8tfi5pJhZQOEv+rwbHSPAwoLaNMNd
         PnerCuGmAF3b5RHhV3wCRX33u5oh1SsTwYHq1r050xlk4VHK0wmPBFBOadkEgBdyvv52
         9NMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785855301; x=1786460101;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v05uFFs4hQG6LmTfuKA4XeVgXPR5RZeVv3+eUBjSWnk=;
        b=H8aKYBjLH/Xsm5C6DUZQ6gX+/fIumyYpE+TMWh7E30vaM5kb3My4DkXeKHjVjeI+/V
         rpxXPJW3zKRhFBN9hLKW8qMgNRUOXa6lCrHpVyBk4DBc1BReuc73bR/nLl3z6C0Pricw
         ifgHRCakOXPYbQX2oyu4SaSkKT5KgLiYUE+yQAa2LLJV5RG6AKlSPzmSPyfosh2yioMI
         6l56Pek6Up1zJbWVMSmfYrevZVuwML4Hu6OFd3qVDefBLA42yD8SrKUraz6qcDroMf4m
         4pPNCyi/8okQkdtt8jEmNfmxhjfGEnsBlC31xGf/mpmt0T60xO/oy8IwCzJHb4nOjxgU
         NVYQ==
X-Forwarded-Encrypted: i=1; AHgh+RrGx3cP0s3kxvEzm3ymcnUT2HiSk6cMWUJgmgbru0rpMlQuHx7xH92n91blpsY7XDAHsKYehpUsbg==@kvack.org
X-Gm-Message-State: AOJu0Yz8RU+nFjCbAtMNq+PVKJNuIkESIGerBgvj0RXqobTJsj+IDAwI
	1UmlCERACD3kNKv0tUsuK5PC61nlxazACcqRn2r54h1vkdB1y4AeSqCDxEptk/Cj3awYXKsQf5K
	2FMJUHVOiPA0CpPcINjmHl7RPKGpnRC6eHUHHeHQF
X-Gm-Gg: AR+sD12kZKYtR0yOeDDoV71Hitb5muHbsAKLfnC0oe9fz2HoaRy1V6STapulPlsDNC0
	uml18zMY7FrNZvgz5j1kZH1iW8Lyv3dYChSOLIfNmPQT4hl2mm4Ey8z3e7ZlhrEofoadk7DvUeC
	28ehiceh9MVIoWqo55Rg3ve5PaXmzoPeMx0z7BrwwsPBXuxVY4k7+K2hwv53is9Dqj4h7dhjSr5
	wzz8/vfnDtuYZ3aXW1lc8jrU4xe9r8C3rKdadq4CbAi+qEaKER+OTsqB3VqnRAZZS+vdyKFC6/z
	0sYNqqxPejCl//YzHALQJmCZErwfbezWv7Cr2+aAx94tS82DcWi4W8CBsarQtI/DZ7ssnkViLjc
	=
X-Received: by 2002:a05:622a:2612:b0:52b:806e:2633 with SMTP id
 d75a77b69052e-52ce3f3aa80mr2415961cf.1.1785855299538; Tue, 04 Aug 2026
 07:54:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260802215459.2769283-1-surenb@google.com> <20260802215459.2769283-3-surenb@google.com>
 <anByp6uVW77uofKx@lucifer> <anGrFIYiPhjxWSkD@google.com> <anGsYeT0zfhxXgNI@lucifer>
In-Reply-To: <anGsYeT0zfhxXgNI@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 4 Aug 2026 07:54:46 -0700
X-Gm-Features: AUfX_myVVWOmPQ2KcnkIumR8CXhkBduyP-MUCTNvy2LReepZgBop01C4DsWPzGg
Message-ID: <CAJuCfpFh+06V8yTLiD4kMHjp8uFV2C-9NMZGZuikhGp81sV6LQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] binder: Make shrinker rely solely on per-VMA lock
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, akpm@linux-foundation.org, 
	dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, david@redhat.com, 
	willy@infradead.org, shakeel.butt@linux.dev, vbabka@kernel.org, 
	jannh@google.com, arve@android.com, cmllamas@google.com, christian@brauner.io, 
	tkjos@android.com, dsahern@kernel.org, davem@davemloft.net, 
	gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CBAF240008
X-Stat-Signature: 5ej3gdnqp6tm3i1cdggt1fkur3as8xs4
X-Rspam-User: 
X-HE-Tag: 1785855301-886540
X-HE-Meta: U2FsdGVkX1+THg/P52sPGNhcPD/kKrHZaYkBhQ9fgPHzC3egvoS5aoL7WeX7RnZNp3pxJm2gbMDMW/zYRKjCeIRLPoTU8cYJID5/kf0FOHjUKJavfPd067Vd7GygMzsxZ/VhEYCHSlZd59MOfk5oT1B28XzLEKKx/XnXjgFg8iTA8sUmm7kTOfZLpVhTYHgS1PUcUVIkFBy+w44YkbfF0UIkTJ4/bPMYpBKXhjVj2pZABA1KTmO9oT231Pp6QilXJXhtgocJ5zJI8JBRDc+BZrGLnKWTcMNcCGAxRV74MCZl+XDYSKrR0a0dIPIBfJl18XRr3AlUfDgDp1xMCNeNvL+eoxN7qxN8j9t6Cte5Zf+7Dq2/MHu4DZDFM99p5s3yDQTwggXnThsG45+60af5tbcFToEQwJFAmc2v1EyYgPFieie5NwDb0pbHZhnJqcS0bbXwNQJdFi3nQyWGK+XMCqrWrcqGyQONJIcmnhBDKJv2y7Bf1E7a1V8NslmRyjb5bGmzcflq9KF4mpncDvrHQzZvJo12ix0655uu604SYRf8QZtOrPL3qcP+cymfv1sKYebu+OHaTHwy7XxOqFaBo/R5JsoV+eepYk9nPMl+ZzEpsze5DT6WFviRhxB/uRh1XdHi81GQF0ba+HoBfOLFBKO+JE5zGtE+Sdmhd8X9hP6zx5LvCiEoO8KM67FYbwYm/QcteGZHjCBI+/rLbdZEasBuH1a9zXMgX4osDEpTqjTha7WHJU+OxaszXe+r5EK8xvHEFTaeXF5mPavXZ6rI2GHTS3EwIyXe7Yn0MpIHRU5kyuJCuZev7ReTXnT7s3POFHqKbFlGFBrnGH+H1FIRg8RP0Bw+aB2tK5WX+u9z81lftLz1OIubv+v9boGE3NCHH2Un6J6+WOkGGXY5DR60xsN1IpsOC2VKJBtgG3TvIKjtUkTWk/ECeeOdepi5ZkgUbg0hB8f2HhKUiDyK05T
 IwqzJ9Ex
 rLj1W4Y2HfLLpSlNBOgRx/UNWZIRl8CCGahkyL9y8h2ApywTMms48s+KoJKRKopSeRx/6x4m3nNyIFWBSR3WTj9SMNrJf/VcvvXJCmnUVmVtZrM9veO9sVK5T/GT/gYpSC5jWfe+9wO8x3/dHx8x4lp2SxOxLCpSKK2xDMhnRDb+q3hQN4DpIKB2MF3u4oE3A1/bWLR4uZvUxqcquqFs9SlxiNJP3fUoltPdNG7zYPKJN2sJR00I2nNe0P6/T90ezKlElIEvSh782PmIMQ7dkvm5tf4aIuaZiLhYGibRc7NWDeSTzjINypcvYYS3KMVK+SvUy88+oORd5JPB0ERmlxqI0lBs8JaNbEsjfr6fnv5b9p3+BFZ6e9+b6WBmOWaETCwggie0J2EDMsK4YqHc0uRnrq803A7kWUzWBXPrc7cDSGKCxPBGknX8Go6EqJ9rzvGqewWpTByY/SrPud0Z8zh8sL8pzNQrRPFzpKrJFUedmrUwwFJweEsRxcj8bxdEct8QGpB8eQKYqqCqTYAKvqgnuod7JUZXn5tUcTUQpXM9RV6PeXiMB+Vw5Yr4YxML4PJW9D4IPiOEd4RZ6w4naCdrD1myuRLcUwFvgo+kKIlFhl+HTg0ozU/neZLH2yIuZs/muPMr1ufjPDz7IwVBU9RWBqck+Y9LvUp9D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 4, 2026 at 2:12=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> On Tue, Aug 04, 2026 at 09:04:20AM +0000, Alice Ryhl wrote:
> > On Mon, Aug 03, 2026 at 12:10:21PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > On Sun, Aug 02, 2026 at 02:54:56PM -0700, Suren Baghdasaryan wrote:
> > > > From: Dave Hansen <dave.hansen@linux.intel.com>
> > > >
> > > > tl;dr: lock_vma_under_rcu() is already a trylock. No need to do bot=
h
> > > > it and mmap_read_trylock().
> > > >
> > > > Long Version:
> > > >
> > > > =3D=3D Background =3D=3D
> > > >
> > > > Historically, binder used an mmap_read_trylock() in its shrinker co=
de.
> > > > This ensures that reclaim is not blocked on an mmap_lock. Commit
> > > > 95bc2d4a9020 ("binder: use per-vma lock in page reclaiming") added
> > > > support for the per-VMA lock, but left mmap_read_trylock() as a
> > > > fallback.
> > > >
> > > > This was presumably because the per-VMA locking can fail for severa=
l
> > > > reasons and most (all?) lock_vma_under_rcu() callers have a fallbac=
k
> > > > to mmap_read_trylock().
> > > >
> > > > =3D=3D Problem =3D=3D
> > > >
> > > > The fallback is not worth the complexity here. lock_vma_under_rcu()=
 is
> > > > essentially already a non-blocking trylock. The main reason it fail=
s
> > > > is also the reason mmap_read_trylock() fails: something is holding
> > > > mmap_write_lock().
> > > >
> > > > The only remedy for a collision with mmap_write_lock() is to wait,
> > > > which this code can not do. So the "fallback" after
> > > > lock_vma_under_rcu() failure is not really a fallback: it is really
> > > > likely to just be retrying in vain. That retry in an of itself isn'=
t
> > > > horrible. But it adds complexity.
> > > >
> > > > =3D=3D Solution =3D=3D
> > > >
> > > > Now that per-VMA locks are universally available, lock_vma_under_rc=
u()
> > > > will not persistently fail. Rely on it alone and simplify the code.
> > > >
> > > > Full disclosure: I originally tried to do this with
> > > > lock_vma_under_rcu_wait(), but it did not fit well with the mmap_lo=
ck
> > > > trylock semantics. Claude caught this in a review and suggested the
> > > > approach in this path. It seemed sane to me. So, Suggesed-by: Claud=
e,
> > > > I guess.
> > > >
> > > > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > > > Cc: Vlastimil Babka <vbabka@kernel.org>
> > > > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > > > Cc: linux-mm@kvack.org
> > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
> > > > Cc: Todd Kjos <tkjos@android.com>
> > > > Cc: Christian Brauner <christian@brauner.io>
> > > > Cc: Carlos Llamas <cmllamas@google.com>
> > > > Cc: Alice Ryhl <aliceryhl@google.com>
> > > > Cc: "David S. Miller" <davem@davemloft.net>
> > > > Cc: David Ahern <dsahern@kernel.org>
> > > > Cc: netdev@vger.kernel.org
> > > > ---
> > > >  drivers/android/binder_alloc.c | 29 +++++++++++++++--------------
> > > >  1 file changed, 15 insertions(+), 14 deletions(-)
> > > >
> > > > diff --git a/drivers/android/binder_alloc.c b/drivers/android/binde=
r_alloc.c
> > > > index e4488ad86a65..84104ba04e30 100644
> > > > --- a/drivers/android/binder_alloc.c
> > > > +++ b/drivers/android/binder_alloc.c
> > > > @@ -1142,7 +1142,6 @@ enum lru_status binder_alloc_free_page(struct=
 list_head *item,
> > > >   struct vm_area_struct *vma;
> > > >   struct page *page_to_free;
> > > >   unsigned long page_addr;
> > > > - int mm_locked =3D 0;
> > > >   size_t index;
> > > >
> > > >   if (!mmget_not_zero(mm))
> > > > @@ -1151,14 +1150,20 @@ enum lru_status binder_alloc_free_page(stru=
ct list_head *item,
> > > >   index =3D mdata->page_index;
> > > >   page_addr =3D alloc->vm_start + index * PAGE_SIZE;
> > > >
> > > > - /* attempt per-vma lock first */
> > > > + /*
> > > > +  * Attempt per-vma lock. This is essentially a
> > > > +  * "trylock". It can fail even if the VMA exists
> > > > +  * for 'page_addr'.
> > > > +  */
> > >
> > > This makes me wonder whether lock_vma_under_rcu() should really becom=
e
> > > vma_trylock() at some point in time? :)
> > >
> > > Or at least have 'trylock' in the name.
> > >
> > > >   vma =3D lock_vma_under_rcu(mm, page_addr);
> > > >   if (!vma) {
> > > > -         /* fall back to mmap_lock */
> > > > -         if (!mmap_read_trylock(mm))
> > > > -                 goto err_mmap_read_lock_failed;
> > > > -         mm_locked =3D 1;
> > > > -         vma =3D vma_lookup(mm, page_addr);
> > > > +         /*
> > > > +          * If the vma exists, we can't continue because we cannot
> > > > +          * remove the page from the vma. However, if the vma was
> > > > +          * unmapped, it's okay to continue.
> > > > +          */
> > > > +         if (binder_alloc_is_mapped(alloc))
> > > > +                 goto err_vma_lock_failed;
> > >
> > > Hmm, it seems a bit odd to me that you also have:
> > >
> > >     if (vma && !binder_alloc_is_mapped(alloc))
> > >             goto err_invalid_vma;
> > >
> > > Below?
> > >
> > > So you have:
> > >
> > > Before:
> > >
> > >                             |binder_alloc_is_mapped()?
> > >                             |yes    no
> > >                     --------|-----------------
> > >     vma is mapped?  yes     |OK     abort
> > >                     no      |OK     OK
> > >
> > > Now:
> > >
> > >                             |binder_alloc_is_mapped()?
> > >                             |yes    no
> > >                     --------|-----------------
> > >     vma is mapped? maybe    |abort  OK
> > >                     yes     |OK     abort
> > >                     no      |OK     OK
> > >
> > > The 'maybe' is because the VMA trylock failed.
> > >
> > > So the issue is you might have a case where the VMA _is_ mapped but
> > > !binder_alloc_is_mapped(), which previously aborted because of the vm=
a &&
> > > !binder_alloc_is_mapped() check.
> > >
> > > It seems like:
> > >
> > >     /*
> > >      * Since a binder_alloc can only be mapped once, we ensure
> > >      * the vma corresponds to this mapping by checking whether
> > >      * the binder_alloc is still mapped.
> > >      */
> > >     if (vma && !binder_alloc_is_mapped(alloc))
> > >             goto err_invalid_vma;
> > >
> > > Is testing for a specific scenario 'we found a VMA but it turns out i=
t's
> > > invalid' and aborting if so.
> > >
> > > So either this check should be removed or you should uncondtionally a=
bort if
> > > !vma I think?
> >
> > This check is quite important and can't just be removed. If you remove
> > it, there's no guarantee that the vma is one created by Binder. It migh=
t
> > as well be a VMA from a completely different driver/subsystem, which we
> > definitely should not be invoking zap_vma_range() on.
> >
> > In this case, Binder rules out that scenario by saying that the VMA
> > can be mapped exactly once, and once you unmap it or remap it or
> > anything like that, Binder sets the 'is_mapped' boolean to false and
> > refuses to perform any further VMA operations for this binder fd.
> >
> > So really this function needs to deal with three scenarios:
> >
> > 1. The original Binder VMA is still there and we acquired its lock.
> > 2. The original Binder VMA is still there, but we could not acquire its
> >    lock.
> > 3. The original Binder VMA is gone.
> >    - Subcase one: there is no VMA at that location anymore.
> >    - Subcase two: there is now another unrelated VMA at that location.
> >
> > In scenario one we can proceed with zapping the page. In scenario two w=
e
> > must return LRU_SKIP because we are unable to zap the page. As for
> > scenario three, it's a scenario that is possible, but not something tha=
t
> > needs to work well. It doesn't matter that much whether such pages can
> > be reclaimed by the shrinker because userspace shouldn't create this
> > scenario to begin with.
> >
> > But you are right that we currently handle scenario 3 inconsistently. W=
e
> > handle subcase one by having the shrinker proceed to free the page, and
> > just skip the zap_vma_range() call. And we handle subcase two by having
> > the shrinker return LRU_SKIP. Either behavior is acceptable to me, but =
I
> > agree that being consistent would be better.
> >
> > So what we could do is to remove this check, but then later wrap
> > zap_vma_range() in an 'is_mapped' check like this:
> >
> >       if (vma && binder_alloc_is_mapped(alloc)) {
> >               zap_vma_range(vma, page_addr, PAGE_SIZE);
> >       }
> >
> > This way we only LRU_SKIP in case two, and always handle case 3 by
> > removing the page from alloc->pages without touching the VMA.
>
> Ah sorry I replied to Suren not noticing you'd responded :)
>
> Thanks for the explanation, much appreciated! Makes sense.
>
> I'm being OCD about it (occupational hazard in kernel development :) but =
the
> inconsitency was concerning there. And agreed it's an edge case.
>
> Suren - that good for the respin?

Yes, I'll incorporate Alice's suffestion into the next version. Thanks!
>
> >
> > Alice
>
> --
> Cheers, Lorenzo

