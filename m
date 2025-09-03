Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE211CA1007
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 02:31:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 074C66B000D; Tue,  2 Sep 2025 22:31:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04C1B6B0010; Tue,  2 Sep 2025 22:31:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA42C6B0011; Tue,  2 Sep 2025 22:31:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D5E446B000D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 22:31:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 687B8119E95
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 02:31:54 +0000 (UTC)
X-FDA: 83846363748.28.B4F440B
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8D2D74000E
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 02:31:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ad0n8wET;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756866712; a=rsa-sha256;
	cv=none;
	b=j2FCPGjw70BgQD2tQrISQncjvS+cRdi982pBp1kfIVurHQfgQ4iV9SoL0L4uHk3KJIJUNe
	JeQpEo+ywJxQapydWTYHDCsaUoROSHdNIaeXipNBO3/2at+PxnfZvR/QrJp8eNiD0oLKQ7
	I6GgAhAa36IELyuwQodEnejStki4SEs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ad0n8wET;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756866712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JaM8jElx76QsWPCI4i/bmHE7wpK9FrSZCqDi9Z/x0BU=;
	b=oBxD4FFoVRUQv/vmxMi/cQjCJAn6p9Laj87HISYUyqDyYCwUPTaDKt/VfE8eIY6JdtRVo2
	2/t639QtBbmEO8EBRTgHDUkSOi2IdOVjzv1KaYKMUcsQly6hlLxUWdReUfFdgMc7u/2J4L
	7Sxeh64+uHV/vCpexR5cexm8akCvWJk=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4b2f4ac4786so47701691cf.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 19:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756866712; x=1757471512; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JaM8jElx76QsWPCI4i/bmHE7wpK9FrSZCqDi9Z/x0BU=;
        b=ad0n8wETbU8aYm0SCd0H6xsUAgD3S4XNkNpWlSKVuWczwb7pNOyuUlkBKNww9o3z1Q
         Fa8Bh+J02qRIMJG+zCv7bd2QsvqqAlerwi9xan1aHIb5CcNNdpM4nu4HcubbCL1x5j5j
         alHZAJ3CmF4+GkgkVyS7yIBaucWAcnQs6o8KzdP2C/7KQlM3PhJlQSwJftDTk0jikuQI
         fZyk0s06LDH8ckLQEoeNteXf2JKjPqcsOtVYLWW/ckJYn5F6n2fWcHCOLT+Pq5ZPHxRv
         QGHWJBiSzZ6phMURA2tTm7D36Lw+pRy7ab0xEdxPzECW+wbzqYOltBs5oQknNy81eN5i
         V6Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756866712; x=1757471512;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JaM8jElx76QsWPCI4i/bmHE7wpK9FrSZCqDi9Z/x0BU=;
        b=VVZ1UaJo051eZYz7T1UcV1f2omOACVKxBfXj453JcRXTgex2j/IBN/fxCkDn+uwavv
         yaWgeysCDdONJ7xu/7I9zRpPct2dC6zWtSagxmYUNlmfpfQtOnHIJgYTFR2AxjImx1cy
         rkJTC4CRXlsp3LSyeQzjnjyAFqGAuc1hdT8i0i09Celd5fqovy7Vqn8bq/owa6K6WUsd
         AMNZePLBFxHxp6+3o1FGu7LG8V4vIlet+S1gmwrjDf5hflfK5jjZtTDkJY35Q89ZiuxR
         p95nQpD6bJxjgVVuXLK/51wcHQ3NbS/GNd5ZbVKtLrPgHdvklW8/whL5o7Sdr/ETc3bI
         YT+w==
X-Gm-Message-State: AOJu0YzU4T5sePb/7OtRqxnV4ZphqSfqypjom16D0H4VC2F/HETXt+o5
	JHe++vZsYhkXcnLZ+Jt0HvipWjDdQo1ylSAdksevkloKh54ZO9FY37ZFaq6ticJFtRsQ0SZK0Vx
	G2OY1MHzwWx/6ejWVe4RX668gsEt7JOA=
X-Gm-Gg: ASbGncugA82z09C3ahdxiOs7JWKT8usJmKyZFkwuTt2ne6+vHyv2j07X7cRV2fFIt4b
	Q43N+ABNU2Rlf2icLmnztL0SIc4GasTONo5JUuFONMbCfRRBUQW0J8ohPvHIbklIUDtXKpQkqer
	ZXRHh+6yUvoOGbXZ0DdLqkHLdkAF2W/bCBPwTi7UVMPRjgi+HTlnW0S0cdLmHU8BqrlB3jUCTvj
	1eO2rx6Hfk97v5xNQ==
X-Google-Smtp-Source: AGHT+IGsu1otmlJC2BFf+whMMlTjSxOF7/4Mm300tUoYFIc19VewwnIHMj3ISJYok6gXjAx3c3Kr8hfeQ69x85fqyg8=
X-Received: by 2002:ac8:5e4d:0:b0:4b3:219:b74a with SMTP id
 d75a77b69052e-4b31dcccadbmr180598031cf.72.1756866711488; Tue, 02 Sep 2025
 19:31:51 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-7-ryncsn@gmail.com>
 <CAGsJ_4yRa65ogB0d90LmtOigGTqQ9mM-eUU6VbmcX63j6vgHEg@mail.gmail.com>
 <CAMgjq7A5Gr2V9TDFg=_S+SjZ1r1gWXTtRGNofuzAgWNYLMW_DQ@mail.gmail.com>
 <CAGsJ_4w7iV0YU+sXdYPrzqXAdaLncoP7bnGx8ELcpETL6y+cOQ@mail.gmail.com> <CAMgjq7AWQtbXMH4iOoV473wJj0TA8SEUyvsWKvsUP_=1oRuH9w@mail.gmail.com>
In-Reply-To: <CAMgjq7AWQtbXMH4iOoV473wJj0TA8SEUyvsWKvsUP_=1oRuH9w@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 3 Sep 2025 14:31:40 +1200
X-Gm-Features: Ac12FXw9QoA8aC-zRqLH3kdz8gE1l6zpGqF39cGUZA-kcxrOVqv_LPaFpOqQt0g
Message-ID: <CAGsJ_4z7BagquRVHoJq612h-_n87F_VuTqRxOnSCoox2qpYmRg@mail.gmail.com>
Subject: Re: [PATCH 6/9] mm, swap: use the swap table for the swap cache and
 switch API
To: Kairui Song <ryncsn@gmail.com>
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
X-Rspamd-Queue-Id: 8D2D74000E
X-Stat-Signature: 1n98z3a787hzf9gw6f98nhh44otqch9q
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756866712-960068
X-HE-Meta: U2FsdGVkX19wz8Ww4IozY7nKrvx6ZsmNmphPqcZe7PhceBF4oABqS+Vxc1vdqqkmmu2fA0s1WVe9Dx42F8IfavjEi0Os37N1lHRNGMD0dtdCi9hMXjsrMD2S3Xcb9IzDNjvkkdxhz4CiJ3pvxcpacLO8msx0/Xaax95TpZIKsKenC4DPmq7OvLF4gxX5jq2XcHlvjizvb/Nehwf84kIaZ/mY25VlqwVPZhXcIkWeoHu+R9dzfEmq1SMzb7QKXTnu28KQraB47402zUnlWNgQvwYSsfKm9ePNkYIu4Mu4GKQU/ulesJnWjB0bPXeca5I1M1S2NZGumuBiXlnwayh2mlaZieoF3tLUpS1OT202tAZGOXuXqUTvmqcxuPhktCrKMSHk65TDf17e/XDEwNo0pDloFY6HhzuXhwxBRb3OG+YWGD+yrzr32higvOSqNbA+FxsdMhbiRbh01950mruxWLAHKeTYKDffsw+Y1V4D6K6pDU9J6mholL9+pmGYnSmMvKA6XcRMkcVh9AnQhxuhGtI0PcS40n1tuT0UdQk1b8MeHqL2FCih66/EcgorQEuLqewKgU2/e7fjU6K18xaX5j04TNUwsg7m2cbkug4N3n8hRYTHpl0XUHM6m3UW8h+zC0jSssqIgzGDDMfWCj2KVLP8lANdTh4Ye8BT8GMZ9F4QKQXL2QZMQvbL6/oiRNUD7cnvQ6dZercZFi+f/9atHFgTJJ5+tigdxed95T5FiMrWA6Z4Sie4bXPlBdN2vw0JkPFE4D63iDCxv+51YKCOQ6qwYypXdwFux4JJtCaCCJNbORyd/i9pj/dZu0z2XRZPbCYQLlYxuGMTeelvwmiEjBDRAy9bxUMpOo5K58+qPDBAdSUNBTUE24YFPqYAwf4jY3M1pF+TI1ys1D9ocN01ydYdkwDCuxn3nBs6omKqHL6dIQgcb3jxpxDWbx+ONjL8GfNz42c9K/WiAESyOkG
 efhzMMXU
 3Fm9FOiW7f/p6b8JXKzlywgqjAMvoDTHEzEGqPcHOdrw69o1vFJRLgUSJIqnhfzVSMSizV7vKDdVcxW+y+rNdwwEVzHFplrzT1X4vhZnCM20OuCCKz7Sgkv1xPs6E6G3tsKDxFz6Z8JMqLO2toMexFfcf8RvBEI5tryi9EkNqAKYMaEfy27U4bhXx3Ao6Gt+4E749mvtV70S621cndn5mPSp+/u0agvIXhD6P8uvxBeSmrgnuRlCNJNMQTFkQGeUmMolcJdSr9m2PJOk+Bct1XuijdF+YXR3VNYJoV3D/RjQG8CPclreN+JBtzD+OzINToFqwH5YDikYYDPtZAY86tKmA5SUL+nfuiLMvfudtObmTKJAzhg1oL9e1g0X5SFtixk1f4aM3ngWTibuIofwxuB6aVRm/zMwUoVxx1FiA1iSrh6/CVIU8ZTsKvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 3, 2025 at 2:12=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> Barry Song <21cnbao@gmail.com> =E4=BA=8E 2025=E5=B9=B49=E6=9C=883=E6=97=
=A5=E5=91=A8=E4=B8=89 07:44=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Tue, Sep 2, 2025 at 11:59=E2=80=AFPM Kairui Song <ryncsn@gmail.com> =
wrote:
> > >
> > > On Tue, Sep 2, 2025 at 6:46=E2=80=AFPM Barry Song <21cnbao@gmail.com>=
 wrote:
> > > >
> > > > > +
> > > > > +/*
> > > > > + * Helpers for accessing or modifying the swap table of a cluste=
r,
> > > > > + * the swap cluster must be locked.
> > > > > + */
> > > > > +static inline void __swap_table_set(struct swap_cluster_info *ci=
,
> > > > > +                                   unsigned int off, unsigned lo=
ng swp_tb)
> > > > > +{
> > > > > +       VM_WARN_ON_ONCE(off >=3D SWAPFILE_CLUSTER);
> > > > > +       atomic_long_set(&ci->table[off], swp_tb);
> > > > > +}
> > > > > +
> > > > > +static inline unsigned long __swap_table_get(struct swap_cluster=
_info *ci,
> > > > > +                                            unsigned int off)
> > > > > +{
> > > > > +       VM_WARN_ON_ONCE(off >=3D SWAPFILE_CLUSTER);
> > > > > +       return atomic_long_read(&ci->table[off]);
> > > > > +}
> > > > > +
> > > >
> > > > Why should this use atomic_long instead of just WRITE_ONCE and
> > > > READ_ONCE?
> > >
> > > Hi Barry,
> > >
> > > That's a very good question. There are multiple reasons: I wanted to
> > > wrap all access to the swap table to ensure there is no non-atomic
> > > access, since it's almost always wrong to read a folio or shadow valu=
e
> > > non-atomically from it. And users should never access swap tables
> > > directly without the wrapper helpers. And in another reply, as Chris
> > > suggested, we can use atomic operations to catch potential issues
> > > easily too.
> >
> > I still find it odd that for writing we have the si_cluster lock,
> > but for reading a long, atomic operations don=E2=80=99t seem to provide
> > valid protection against anything. For example, you=E2=80=99re still
> > checking folio_lock and folio_test_swapcache() in such cases.
> >
> >
> > >
> > > And most importantly, later phases can make use of things like
> > > atomic_cmpxchg as a fast path to update the swap count of a swap
> > > entry. That's a bit hard to explain for now, short summary is the swa=
p
> > > table will be using a single atomic for both count and folio tracking=
,
> > > and we'll clean up the folio workflow with swap, so it should be
> > > possible to get an final consistency of swap count by simply locking
> > > the folio, and doing atomic_cmpxchg on swap table with folio locked
> > > will be safe.
> >
> > I=E2=80=99m still missing this part: if the long stores a folio pointer=
,
> > how could it further save the swap_count?
>
> We use PFN here, it works very well, saves more memory and the
> performance is very good, tested using the 28 series patch which have
> already implemented this:
> https://lore.kernel.org/linux-mm/20250514201729.48420-25-ryncsn@gmail.com=
/

Alright, I see. With the PFN, we already have the folio.

>
> >
> > >
> > > For now using atomic doesn't bring any overhead or complexity, only
> > > make it easier to implement other code. So I think it should be good.
> >
> > I guess it depends on the architecture. On some arches, it might
> > require irq_disable plus a spinlock.
>
> If an arch can't provide atomic for basic access to a long, then that
> justified the usage of atomic here even more.. The read has to be
> atomic since swap cache lookup is lockless, so the write should be
> atomic too.

I actually confused atomic_64 with atomic_long. After double-checking, I
found that on almost all architectures, atomic_long_set/read are effectivel=
y
write_once and read_once. However, many architectures override these in the
common header file. This seems like a spot worth cleaning up for those
architectures.

>
> Xchg / cmpxchg is a bit more complex on some arches, they are optional
> in the swap table anyway. We can use them only on arches that provide
> better performance with atomic. I believe most arches do. For the xchg
> debug check, it can be dropped once we are confident enough that there
> is no hidden bug.

Thanks
Barry

