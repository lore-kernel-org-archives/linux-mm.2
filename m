Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7CECCA1007
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 02:12:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 023DD8E0008; Tue,  2 Sep 2025 22:12:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3C538E0001; Tue,  2 Sep 2025 22:12:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E52028E0008; Tue,  2 Sep 2025 22:12:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D31E68E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 22:12:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 79A3C1404AB
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 02:12:49 +0000 (UTC)
X-FDA: 83846315658.07.53D2D57
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9B95BA0006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 02:12:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Gc2BVzYE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756865567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NHNEMXnQPJ7mnboxGgw4UKiDM5+vXgQtKv2FqnlXfUU=;
	b=NASc31iMsBPowMgt6JUTm4/4LiknEcMf9Rtqb7BPet0+p+nr0SGjm1BZyGDAQuxyi5nnF4
	172xDJRb5E2nBgY+ASXfxE6l6k2iZYZKvfZitoHvS1GeftwGNKvnHhu8QDuP3jBLju9TZ3
	xAM+M9hQiueRev4dTy4BW9C7nhUtPHk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Gc2BVzYE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756865567; a=rsa-sha256;
	cv=none;
	b=Qh51UqB+fDKEcrp2fvtQv+5UHu1KPvzPHfFe206w7G1UNgymBEVGVuyczaFXWz2tMBO1Bi
	FFMtqUHAnvGFDzBrsxveVcnk95WGHlFEXHrKp3LkampPz2D8BlUN3QLKkuI93ZaiojVHcN
	Lq2D+zJVRD9qtwvFjdwHwhAVTEFOma0=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-61c26f3cf0dso9241220a12.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 19:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756865566; x=1757470366; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NHNEMXnQPJ7mnboxGgw4UKiDM5+vXgQtKv2FqnlXfUU=;
        b=Gc2BVzYE3VBW3EpxQ6FVJfi4Uva2mbvAgReLGDugR3fEv5bdzUFEpjymZWoXasEpAi
         6AGIwAVWx8PJ1TOwxjCDzLG0hLNRV/0IEySnGS2qZ8FHD/AhLTh43+6oulySurYcrgIl
         28GfCMc1ASsRnNsL3+NiKJhZZv0Nv6M+5gEtk5w7QVDCI92gdFlWJ9qDY4BBHmz9JKLF
         ldLsY3BYnDXEXjHhFZef+pcwnLTHlAUOYoQl827Y95W5AqUwitB6/X8U0gOZ6aiakedV
         It2h316lShq1YyndRLmXXMDTJbqalletv5nqinNyOJHaK0x2LPm8s2DenjdaCvEFBqMe
         eNpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756865566; x=1757470366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NHNEMXnQPJ7mnboxGgw4UKiDM5+vXgQtKv2FqnlXfUU=;
        b=RH05GX04g7OdJjXLuROsfRYu1BmOMgQulodc+KptQCakjBy58xI0rNsKXaeDMoRHcg
         DulJDDagal39L/Ut78yMtKifgs1QIW8DDnXrHLR1uLNWPrcp0i03wenuxZjMGtTvckFu
         HHo9skZD1oEuW/jrNr6cfm7SKfOQtnBoi1OEgaedty0JpYAUotRvkHUUz0lffC9k50qH
         gbfcDoEaip8K20hxyDeivVS+jHZcH7r8Qery01Q8avslRr6nU/qbaH1t0pe0hxg5o1p6
         iYMmL5JZscOAjZccqplFgb0HI+nMilau/aOPGDVYgl2G1yhRk8qUC+Rf5xP+oljGTEGP
         F7Ww==
X-Gm-Message-State: AOJu0Yz979hQ0Fuv6rQFFoT0YuXjlyAV5v1EWPdFGIRYx95yiYGPn7qc
	qvr7p/KisVbps/OK3qM76QTaxLO4bv9ESTx8vpk95C6R9SQ/78+EPCHFPSaemWuFmFSscI1Vb/W
	fXRzkeHMtzWy5CrZfdoKYPxZOuktPcuE=
X-Gm-Gg: ASbGnculewNV9oe8aDQhO1Cg5YXCoiS9SpuVNUXq10V1yr884z1nBNruFdzY4P9MlFt
	ItpxWZCetdfDuw7Q1nzpbIzaVY/HFLBdd6v9/Xj+AL003ef/G86QStxKLHOFJJIqLzTVMn7kuWR
	k0lQMk8NEuiFrBMv7IUfw/dhSGVyzRBv1PaZEl4kAwki0UXdnzXvRw28ZrbNkSeLBfZy7ZU6VpD
	1f+wxHNygLfGtkwQozOkA==
X-Google-Smtp-Source: AGHT+IHJvSP0ZDGFIfI+a5x+hY3UFf7dXrZwZcpOSVJter6Xgczmltyt1tECkViagWTXnDDgWy36JsqoLxz8HOvYWbw=
X-Received: by 2002:a05:6402:2787:b0:61c:fb8e:ab6e with SMTP id
 4fb4d7f45d1cf-61d26d923famr10793090a12.32.1756865565722; Tue, 02 Sep 2025
 19:12:45 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-7-ryncsn@gmail.com>
 <CAGsJ_4yRa65ogB0d90LmtOigGTqQ9mM-eUU6VbmcX63j6vgHEg@mail.gmail.com>
 <CAMgjq7A5Gr2V9TDFg=_S+SjZ1r1gWXTtRGNofuzAgWNYLMW_DQ@mail.gmail.com> <CAGsJ_4w7iV0YU+sXdYPrzqXAdaLncoP7bnGx8ELcpETL6y+cOQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4w7iV0YU+sXdYPrzqXAdaLncoP7bnGx8ELcpETL6y+cOQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 3 Sep 2025 10:12:09 +0800
X-Gm-Features: Ac12FXwXU3cGEpdDG2B4PbKuGKDDUeEJi395AB_neJedEa8KRWW3ViJ9k_m11YE
Message-ID: <CAMgjq7AWQtbXMH4iOoV473wJj0TA8SEUyvsWKvsUP_=1oRuH9w@mail.gmail.com>
Subject: Re: [PATCH 6/9] mm, swap: use the swap table for the swap cache and
 switch API
To: Barry Song <21cnbao@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9B95BA0006
X-Stat-Signature: jomntqfbipytof393fn6re81ahwjp9ee
X-Rspam-User: 
X-HE-Tag: 1756865567-992682
X-HE-Meta: U2FsdGVkX19UiRPa2+NOM9Zx8bwq3u1T8mZ0Pu8jmRko+fbxjfh59eS3o9RgKtmvnEJQgCNoV3UQfku8RIn9aslxz/F2ov8SGl8zUnak7sZkFwQVuiMDSR3VJfhw34Pr/zBVEQV8aJ+Z3ZGFJ8asYY/ucA8g9FTDqZS/vhRQocnWv4DLxF/rcVJOZQU9voR9nI/kH4nospFdDXToWYEXW7Ei2h6Mgkk/k0lpSyh94j8NAc8H/492t7O/Ab0Nau6lHJ5XdRfBl9keC19ihyZKwNfsFYTm3zDR/t7qQVJVn1fgs+4AiREOz6msJ5OToe2KyUIvGPsSy25C4OA3nxLQp87MK2aUveym4c5uJ/Ruvjc+ycpBBN7FCym4NNH2Vyr3kWtADW0/ZBaCzM2ImX2/c032Wy4m2B/A52JSWtxmppUWh1Y6D9CDjkVTsGdv4HwdjI8yMPwlm1VTT3jznxoGSPF83jsp0/NG/5PQhaZXXrKz6CV0QJFQMujnsxyovaMR4DLhL0gYKC4+Wf6dYIObjGuxWUFVZcDWLWzdspgXBGUMKgZHD4/e3Lsh9q3PqvD/ql1EwOzNTgwcNLHdqnvrVP8aH81tODVzoPwROz3571Z78dtB3kgBYznVGwR0zu5r6pupeazk8AdK1RAdkBEMSTW9UXBQtaE/y7X00n8wf1Lc9DQ55jVWzgJPco+BLm8SGPIlRLlNFe4ES2DB1qO2xa26yQFCPFQrt6D1U880zvzd8vU/I4KwNgKKI+DPxSJ1ge0F2zQDL/osOKmvyVpLCBqu+JNg6pqry1xQS5FJolmFxqHY0z9KkyyKmf4pjtJ1kxcXgh82rV5agT5dYHyxkXU0mISr/ueU2VEXQEsqcnczuRgztVTl+coVvyo8iDNpNz6/fsaOZ/9Vie5fiIPHPSr436j3B3WOCilEXcKI6SgnOZ1JaZQEAx8J40HU8NaWrkPQNGOeF94zTXZTLnu
 BQvbJY7o
 stkhFlY0r0wonh8Oi8FpbTi0H0vtqpVTcIcA10wzM0oSNMBYKdqydYeV+SyfCNxRMzS7XO24T5AIVKvxczzeKxnQt9YHRMO9NWV/ANUp0BmDrScFYF04tuZgarGhnqBz7V9mR+qHJlSdV66HtIEs8sQIlVzu01o3f1fIRu1DiZLp1LJRVXdgUNdX0Eb3rsatbHoV9HXtcANUduy0El7gz3Vs+lS7BHyTRrzcIL+Nm1ImPg9eesTTUjzhlXe2l7PtQb+FBXygGLg++YA2ojGctOjHAQBrRNM4+D/vzyQ6Kg2Xi2USzG/na5ZvxwQGTfeyLEdnqUlP62WzELpMMHfvapCRqddQqGX8Xbk1UcaZwZQ+dN8n3X6HZqgBW83BNaDg52NbZ2FkPan9IKw2wzLpM0IvK+XqyPE4VmuG6Qi+Ou+NQdBJil+wxhS/Ngw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Barry Song <21cnbao@gmail.com> =E4=BA=8E 2025=E5=B9=B49=E6=9C=883=E6=97=A5=
=E5=91=A8=E4=B8=89 07:44=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue, Sep 2, 2025 at 11:59=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > On Tue, Sep 2, 2025 at 6:46=E2=80=AFPM Barry Song <21cnbao@gmail.com> w=
rote:
> > >
> > > > +
> > > > +/*
> > > > + * Helpers for accessing or modifying the swap table of a cluster,
> > > > + * the swap cluster must be locked.
> > > > + */
> > > > +static inline void __swap_table_set(struct swap_cluster_info *ci,
> > > > +                                   unsigned int off, unsigned long=
 swp_tb)
> > > > +{
> > > > +       VM_WARN_ON_ONCE(off >=3D SWAPFILE_CLUSTER);
> > > > +       atomic_long_set(&ci->table[off], swp_tb);
> > > > +}
> > > > +
> > > > +static inline unsigned long __swap_table_get(struct swap_cluster_i=
nfo *ci,
> > > > +                                            unsigned int off)
> > > > +{
> > > > +       VM_WARN_ON_ONCE(off >=3D SWAPFILE_CLUSTER);
> > > > +       return atomic_long_read(&ci->table[off]);
> > > > +}
> > > > +
> > >
> > > Why should this use atomic_long instead of just WRITE_ONCE and
> > > READ_ONCE?
> >
> > Hi Barry,
> >
> > That's a very good question. There are multiple reasons: I wanted to
> > wrap all access to the swap table to ensure there is no non-atomic
> > access, since it's almost always wrong to read a folio or shadow value
> > non-atomically from it. And users should never access swap tables
> > directly without the wrapper helpers. And in another reply, as Chris
> > suggested, we can use atomic operations to catch potential issues
> > easily too.
>
> I still find it odd that for writing we have the si_cluster lock,
> but for reading a long, atomic operations don=E2=80=99t seem to provide
> valid protection against anything. For example, you=E2=80=99re still
> checking folio_lock and folio_test_swapcache() in such cases.
>
>
> >
> > And most importantly, later phases can make use of things like
> > atomic_cmpxchg as a fast path to update the swap count of a swap
> > entry. That's a bit hard to explain for now, short summary is the swap
> > table will be using a single atomic for both count and folio tracking,
> > and we'll clean up the folio workflow with swap, so it should be
> > possible to get an final consistency of swap count by simply locking
> > the folio, and doing atomic_cmpxchg on swap table with folio locked
> > will be safe.
>
> I=E2=80=99m still missing this part: if the long stores a folio pointer,
> how could it further save the swap_count?

We use PFN here, it works very well, saves more memory and the
performance is very good, tested using the 28 series patch which have
already implemented this:
https://lore.kernel.org/linux-mm/20250514201729.48420-25-ryncsn@gmail.com/

>
> >
> > For now using atomic doesn't bring any overhead or complexity, only
> > make it easier to implement other code. So I think it should be good.
>
> I guess it depends on the architecture. On some arches, it might
> require irq_disable plus a spinlock.

If an arch can't provide atomic for basic access to a long, then that
justified the usage of atomic here even more.. The read has to be
atomic since swap cache lookup is lockless, so the write should be
atomic too.

Xchg / cmpxchg is a bit more complex on some arches, they are optional
in the swap table anyway. We can use them only on arches that provide
better performance with atomic. I believe most arches do. For the xchg
debug check, it can be dropped once we are confident enough that there
is no hidden bug.

>
> Thanks
> Barry

