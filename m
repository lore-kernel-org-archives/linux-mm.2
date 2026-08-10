Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A024C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 21:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE89E6B007B; Mon, 10 Aug 2026 17:00:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E99776B008A; Mon, 10 Aug 2026 17:00:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D88E86B008C; Mon, 10 Aug 2026 17:00:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B05DC6B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:00:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 364D61202D1
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 21:00:32 +0000 (UTC)
X-FDA: 85086578304.08.B3EF361
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 401B4C0002
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 21:00:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pVXxXdBU;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786395630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aeKlJo/C9IF2FWChtlIU4TSN9rzPXmzQ3Z7bbkbSSDc=;
	b=TB6YHP1uggvKW22JmJavN9RoTB1ET967/UFYveNTP+Pcdqf5IVlKidwb7hqSdnDmGSGQHI
	BdHp3td6bjP50VcKVdmWjev0iOTmeDvGQfz+gPiYMtq38JkVH3W96FntptM8agd9E62nQx
	2SoJ63kOsGYaUqd9lPeZ8p9o05XDPm8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786395630;
	b=cXOBQNrke3kHbzXnARkhGVYTJYjuT1DHeSqg7LhlbQoHYGTcyM1/ku0C8mom/xjxFzmHOd
	j7k7yDMBmY8lLU4ZOwrD61Ga96RH2gc9il7xfyZQcu0TLnPzgBUz3V3aETyiebxJ/r9GIf
	0nQ1SQKErBcu3pePxyj0vnyzjHnQsJM=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pVXxXdBU;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c01c79467so26621cf.0
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:00:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786395629; cv=none;
        d=google.com; s=arc-20260327;
        b=WIrOzEYgebjh1UIksWfoO11q5M/Fj600i6Mr1hdquJm/SttQgxqvoIrSrlvQwvfvim
         3k/PPnJQF0xaTQHyiebSN1x/I3ebxYQE8r2TbQ3JG8LCjuxODOq+Pe5NJ2gk80ScVlXZ
         Pxi5+d7741LzPbZ1fAh0kLC5hmBdP8tUj5jFsyX550/FquBALrW0YKd6Wz1TO9c7or29
         aSJO4pGjdGM+Wg+x+J+6nKUfgtR32eWJRfTOWpE5Tb2GhsXeUXpLgDcFdeSqwk0XD6Ze
         RSpEURzuPrIi6wAZC8+XqhQDUKOnKygFOAtdgo8PT/rU7hq04s0yGeBlU/JIGaSdNM4T
         ObKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aeKlJo/C9IF2FWChtlIU4TSN9rzPXmzQ3Z7bbkbSSDc=;
        fh=kEY+YC5qlFRRjEAuPrFlokJamdTXcMznDhzhc61nXuo=;
        b=TjzaBeJUAnJwnr7mesuI0rP/W79W59GGISdXkHYx7epyspw6jIX61qRR9ySJHjJjHY
         t98pT1vFQxZ9X6jbabe8fqKHYkByDpkPgB/zmPi8RwInoh13aUHxrppOJ5bxrXDSabpB
         cklJTmwa4pjgYr2+S2e3lXw6xmdvyZZThbujFkL5hLlBka5QhWzE0glv2aSc/9gzheq/
         jbwQdsl7DZfMVb+F1j6Nq50gR35dQvhUFntSPJaH6wm/r/CAGXnZHlGq8J0Ubp/Zl8z2
         lJYg32A6/YzI2ftqJH821Gf4OphcRPEzPMFXWAUBhVa9F94gQYTkG7IG+qeJQQ+fWrhb
         tRog==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786395629; x=1787000429; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aeKlJo/C9IF2FWChtlIU4TSN9rzPXmzQ3Z7bbkbSSDc=;
        b=pVXxXdBUoWjhup1p/2h0UlzmpeH0RHxMYP3Si7vrUX23QGc3p/4+uc8BNWmbNgQZOq
         jGQvYR+Y22gORL07JT4nsKzLNwARMc0MG3PBnal51XG0HNlKCCYY91UmUqijFLFMcNHQ
         DT/jZ7BeF91AyJWF+TV1LiKH/eTwO5cSt7E55aH8kFtxPcx8NmxHRK6DT5YEf4hNbBWf
         y/4RtUNsJg+hn9uRA1itN9CrBtNMk9H25Yw/qo6qjO2xS+d/QscNoU7d8tsrTuTL1ftC
         KpqwE31WT7txCMV7Jh18AZSJrFaczyczKl6QOgG3WQidY60GzOmEvFbofaDSTcxdtHDy
         wKpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786395629; x=1787000429;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aeKlJo/C9IF2FWChtlIU4TSN9rzPXmzQ3Z7bbkbSSDc=;
        b=NUprPgDrOgaOEuAePX480a8WRv1tTwEQ6vJJ4JApbGjsIekAjCvpZq4ZS6Cy5bndT9
         53btS7dRzfuFzmn3B6EqtebMqNHJj02JnHZl2sH8OUijxPUH0hWsIkTCSE6qNypAQ7BT
         +sMOGBfQIaoNv6ooTg16m/W0C894oWAoi+XlyQg28bPt3nz6/fACfVwovdpV/dxmkhLg
         vCrBOXyTYrSKcuU8WSNhimIuBjPkq6kfEx4R9l1ySjbVyRWEbat6GDnOogUPQb5/UhD0
         bp1ZCNVxD1ebemUNADcfytoKsywQBi82oabB0zJ6v5yFwS9EGgSBkijO4HvNnPAO6yjL
         qP4A==
X-Forwarded-Encrypted: i=1; AHgh+Rod6YQHNeIo7MIz11LdoXN7QrQ6R7iGQFD8a1csFA2rvOxYLZUKo46eumHW+Bh1KpSACo6TpTJYBw==@kvack.org
X-Gm-Message-State: AOJu0Yy1sZNSC/XqlEKrVg2odAHA/HXUjitx7DQqb97eJ+1TRyzPwUHS
	lHg7bceqbKw9pEKvIXy0VPXzeV723y5+N9QKaTcpMut0TbzK8nEylF+tqtLAZptc7woeXR2S5cU
	hwzQzo707AwTL8GKsn11tSwCSf2NHstYU6KnQ65Zd
X-Gm-Gg: AR+sD12DCkeoI0gvLlNpFJV8GzZhCyaWxYMOsBFNJ6Ec6RiFm2HUtfkXdsQlyvE3qTs
	dq+Vt4siTY06DexILC5P1RHXfWenUgntwK+hoHEH9XZNuoQ6CfxSKeRg6DNn/r4QYIPh6/ozRIA
	tkP+aKiv5vU6LTTiMDGwJFolZdx1tYcJWZzYegj/R9u7AEviPfClFWoAwwIUAx7FtoYdFenyHPz
	pNxqsR6TxvYhxPa1sugS/ZyBK1FuVvMcUg9ucVZbqV4/UF88tVUJBXwPOHo9bHUAI8fDttC9FAs
	sbw9g+mFcg0/eEQAbOQ6vtyFKa9Nj2TCbE349lkuHbSjReGorchpfw==
X-Received: by 2002:ac8:6104:0:b0:517:5e32:2d14 with SMTP id
 d75a77b69052e-52d511fb9ddmr2293481cf.10.1786395628636; Mon, 10 Aug 2026
 14:00:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260806200548.3124802-1-surenb@google.com> <20260806200548.3124802-3-surenb@google.com>
 <anoZL76y3WGXMArB@google.com> <CAJuCfpFCK5ycO6s+dD35YtU6zgNdivfe6P3cVnd2VxPYfGXHDQ@mail.gmail.com>
 <anojoFPijbCloUXL@google.com>
In-Reply-To: <anojoFPijbCloUXL@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 10 Aug 2026 14:00:14 -0700
X-Gm-Features: AUfX_mwveKCjTyY76ZUcAzzSSNA4_OUdgAUMYP4JBZHh4wah9m0LDMZjkeG4kRk
Message-ID: <CAJuCfpGXBTRUUtCCpLPT9v1LZA6UHo0yM3y68Kwhxs7S03z+5A@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] binder: Make shrinker rely solely on per-VMA lock
To: Carlos Llamas <cmllamas@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, ljs@kernel.org, david@kernel.org, 
	willy@infradead.org, shakeel.butt@linux.dev, vbabka@kernel.org, 
	jannh@google.com, aliceryhl@google.com, arve@android.com, 
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 401B4C0002
X-Rspam-User: 
X-Stat-Signature: 1gd5dwm6ig88incq3fdetijtuydf8eb6
X-HE-Tag: 1786395630-258849
X-HE-Meta: U2FsdGVkX184/mo38l2YepMbCn2B7DWoPpJlutKY9jA63kIH/ZyYwoU3V69EUgiW3bvpUXfDDVpgqxq3rizMtwtbVVj4FbsOe202kjiWeq46hV7Np57Ag4mQ+1rUMhsEwTYT9uxq5kk3/iJqrRGQ2rbbv+yfJgkHS8ry6kDE7ApYvZ+0D44G5OObY2DyrPc8LuWQoTZrcBYQRUhWtJfunx9SWImWS2knkNlgH0KY4orxNJ+eZmKSGUf2iwGKjVilQ4+9c594/nQMB2Y0aTqka4aGMmNXOIVm3Y+95oygXXg3qrgRuIw617WxsUaLiWRMADiV4iMeHRCUlWkNjbTmLhJHbAhRro2ME/7VPkasecf8y/oI3Ax2muHOhXdv/zpzSPPfqbQi18p7gsNpMslIHTydlMpPbBIY/9rRpEDtfxwF8C34Kagk6HTKSSG/qHpf9X7C/1oNXUb7gLG8vu56hmi8w22p8mRHbNueLjFO1pC8KbYNmKrlk/eP5vJWzvvQ34z6OL9bEuJNOLAffZN3O77iR3hzpHOT6hsaPg4pE7cpuJZK+doPuN9CP8W0ZbUZWFipZLe4kFDe/6FIwRiXC8EvDgcLA3ZXjIktrApo1kItJ9zyGS31sLfi++0LLBUzeo8fIQIUmpzfXCr6tBrsulErdE7opxFaYh+kU0OdFB4P53xabSbVaUO+HPMircwPayyMTPEOlRwajg3mUIi2OIDmSkMgbO+leMFhOYbusLQ5XGIqnCUF5FUMXtTVrzvQVRrydEw9wJD+o1PeUwR/H7PFEgQu5U7pkkKIPWLcIl6v58HU9jRgJ43XELletf1jA3lRt2csgmG0vhVbNjHoi8/dn11dGvcraA7d9hKU6U1ZSoBvRCd+mETZtXH4sOse19NfSHZEToQOu0+5de63tq1MBeqf6uN0fLRfU+0y1XqxHZGJ9IZ0Iyv3meIXN4ACiTww/tA1Ba2sm18Aqv2
 aPmOUDx6
 Iyd8Cg7yD1StQ0b8FcA/SsFvBGnOTVsCDcQvsZcAqh9yE4ipJkZ+3wTvBoWkBB/pCg27T2nAzHiB5fxVGngr9XchMUvrp7vFGWeLT2BGTk/ESu8ll+c2SWsnJ2Z9yXhXrIv3PjAPqVirfCamCioupFY8mDoMZe0dAT726kftyF8NyYvJOakxB8j4kkYbGtlBo9J9Jahx10OtKDxf6HWs0NMmn9hcVGi9cpDtkyRVG3D5ASMVmQn8Pe5oASOZIT2ujLr/Q2rQgfUAsu6ipZK72+iQpc/HZNKAz3j2cJF97CUYnTagGZpumCWuKnGJYfWclh/7yw516BIfFSvYiTj7a1eE8MC55lSmaAdiGZjp/dZTQBr7xOx+ccWGp5fdMXLo1iGtOv2in4gmZbyc3rq7+LljXb9kqXZhlcfeJXbKVX0Q+C3JaQIxQB6C3W/p6ypZslsH0GqAIyi7E/yqOYss6KjgNTTvKYwTrCjbzfaI6bI9/HHVGpqXVIgM/4WoHOANd4tRegr7V2P+ckcmOa8ZaVEn3R96NgAZgXbyAvPxrSxbHkyRiGqzXBhzMOGA/1R9e6rvX/W7eUinOGmy/YeR4ZrVFfo3Ybj8brP5aOPWby1BOHns/HWHi04jbgnhJ/7MxdYW6tXdQObRTDI79PprOEdKz1LHFH0x87MBj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 12:16=E2=80=AFPM Carlos Llamas <cmllamas@google.com=
> wrote:
>
> On Mon, Aug 10, 2026 at 11:54:04AM -0700, Suren Baghdasaryan wrote:
> > On Mon, Aug 10, 2026 at 11:32=E2=80=AFAM Carlos Llamas <cmllamas@google=
.com> wrote:
> > >
> > > On Thu, Aug 06, 2026 at 01:05:45PM -0700, Suren Baghdasaryan wrote:
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
> > > > The removal of the fallback does not affect NOMMU case because bind=
er
> > > > driver depends on CONFIG_MMU.
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
> > > >  drivers/android/binder_alloc.c | 45 ++++++++++++++++--------------=
----
> > > >  1 file changed, 21 insertions(+), 24 deletions(-)
> > > >
> > > > diff --git a/drivers/android/binder_alloc.c b/drivers/android/binde=
r_alloc.c
> > > > index e4488ad86a65..c13a588c37de 100644
> > > > --- a/drivers/android/binder_alloc.c
> > > > +++ b/drivers/android/binder_alloc.c
> > > > @@ -1142,7 +1142,6 @@ enum lru_status binder_alloc_free_page(struct=
 list_head *item,
> > > >       struct vm_area_struct *vma;
> > > >       struct page *page_to_free;
> > > >       unsigned long page_addr;
> > > > -     int mm_locked =3D 0;
> > > >       size_t index;
> > > >
> > > >       if (!mmget_not_zero(mm))
> > > > @@ -1151,27 +1150,25 @@ enum lru_status binder_alloc_free_page(stru=
ct list_head *item,
> > > >       index =3D mdata->page_index;
> > > >       page_addr =3D alloc->vm_start + index * PAGE_SIZE;
> > > >
> > > > -     /* attempt per-vma lock first */
> > > > +     /*
> > > > +      * Attempt per-vma lock. This is essentially a
> > > > +      * "trylock". It can fail even if the VMA exists
> > > > +      * for 'page_addr'.
> > > > +      */
> > >
> > > Do we need to explain how lock_vma_under_rcu() works here?
> > >
> > > >       vma =3D lock_vma_under_rcu(mm, page_addr);
> > > >       if (!vma) {
> > > > -             /* fall back to mmap_lock */
> > > > -             if (!mmap_read_trylock(mm))
> > > > -                     goto err_mmap_read_lock_failed;
> > > > -             mm_locked =3D 1;
> > > > -             vma =3D vma_lookup(mm, page_addr);
> > > > +             /*
> > > > +              * If the vma exists, we can't continue because we ca=
nnot
> > > > +              * remove the page from the vma. However, if the vma =
was
> > > > +              * unmapped, it's okay to continue.
> > > > +              */
> > > > +             if (binder_alloc_is_mapped(alloc))
> > > > +                     goto err_vma_lock_failed;
> > >
> > > The comments seem redundant, the label is enough. This works:
> > >
> > >         vma =3D lock_vma_under_rcu(mm, page_addr);
> > >         if (!vma && binder_alloc_is_mapped(alloc))
> > >                 goto err_vma_lock_failed;
> >
> > Yeah, for the binder maintainers what's happening here is probably
> > obvious, but when Alice explained the logic to me, this comment really
> > clarified what's going on, so I added it here. If you insist on
> > removing it, I'll do that of course.
> >
> > >
> > >
> > > >       }
> > > >
> > > >       if (!mutex_trylock(&alloc->mutex))
> > > >               goto err_get_alloc_mutex_failed;
> > > >
> > > > -     /*
> > > > -      * Since a binder_alloc can only be mapped once, we ensure
> > > > -      * the vma corresponds to this mapping by checking whether
> > > > -      * the binder_alloc is still mapped.
> > > > -      */
> > > > -     if (vma && !binder_alloc_is_mapped(alloc))
> > > > -             goto err_invalid_vma;
> > > > -
> > >
> > > This introduces an "extra" change. We'll now release pages without a
> > > valid vma (e.g. after munmap()). Before, these pages were expected to=
 be
> > > released via close() in binder_alloc_deferred_release() later.
> > >
> > > I don't see anything wrong with it. However, it does seem out of the
> > > scope of this patch which just drops the mmap_read_lock() calls. Or a=
t
> > > least I don't see how this part is necessary.
> >
> > This check came from this discussion:
> > https://lore.kernel.org/all/anGrFIYiPhjxWSkD@google.com/
> > It's added for consistency when handling cases where the original
> > Binder VMA is gone.
>
> Oh sorry I missed that thread. Yes, I agree we can reclaim these pages
> earlier if really needed but my point is this is unrelated to the change
> done here IMO. I couldn't figure out why that was needed.
>
> If you are keeping that in the same commit it's probably worth adding an
> explanation to the commit log?

Ok, I'll amend the commit log with an explanation for this change.
Are you ok with keeping the other comment, or do you want it removed?

>
> --
> Carlos Llamas

