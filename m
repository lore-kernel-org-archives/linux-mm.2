Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A422CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 20:47:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9A546B00B0; Tue, 16 Jun 2026 16:47:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4BE36B00B2; Tue, 16 Jun 2026 16:47:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D173C6B00B3; Tue, 16 Jun 2026 16:47:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8246E6B00B0
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:47:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0951B1C3B3B
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:47:37 +0000 (UTC)
X-FDA: 84886961754.22.C443AD9
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id E62AB18000A
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:47:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eXyzLQ7A;
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781642855;
	b=bGJzI93hvuq5x6x8WSDSauaOTt2RffAzj/rQnH0oYSUTYSnAWnC0qkSIICNQe+YqHlvxno
	uxj/V/JTrAm7E3tKtCVb19z049V8p2JCnFGYZfDrZRtIVZm/ZWxp4//Tkf1Jrj7j6x8fzT
	9A5g32p53Bo7C1VVc4py9b+ZpYA7oBk=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eXyzLQ7A;
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781642855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BOzw3QtUmoBO3cAElRCyupjJm7YaXn8FH12Din3toF0=;
	b=IoKc9vloPgk7RZZ1zgivhwmmtMnnhotVRBaNN3F0mYRdqZAMud6JJegUvoYtCV8VtVxEK3
	JKhmwIIkUdIkNsOcKxOVfgxefK9zdOUw4j7hLK1wNBjS6fBghVxohfgO8/AlbTWR3JTTnl
	4eAG3kTjl6oR1LB361HC7THtWSxCOy4=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-bef1e6423e7so551684566b.1
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 13:47:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781642853; cv=none;
        d=google.com; s=arc-20240605;
        b=G5qhYKDHx1kl0vcBLOSehHvBh6yiJJRp1DxXna2ZSkGip43hcU1505wcLZrqPKjPPE
         c0fT4KvsNLnVj+5NSeM/RccJbeASRZFN5HPfVNQg0530i2RaRo7ckunxE9CGdhjW3uZ2
         0EezMiTHfplWvHlSgoEMUhJmGa7Xo0FwHTFbwnNDaItvlNO34sozXXkoZeFDHUXFqdsl
         TMoBPq1ni8xW3IgB6gWWff0YGB3IZO6RfuO1TZu9X4CLDPXqObOVcbEIF+ezs6IS/k+p
         7t13Bq6YJ6qEnb6SiYVm0phycKYPhU1zm6xWwe7bE3We1K9Gw+Zjm1QxP7iB2NkRVE5g
         P1wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BOzw3QtUmoBO3cAElRCyupjJm7YaXn8FH12Din3toF0=;
        fh=a33Jd0eM6xY5RGPK75i+apHlksz7Tly3UcvLGQd+wyM=;
        b=hjElXGmcLE/CTEotl2XGWB2w5lmAtR3AJZmulnWSdpIynT5YTh0ag3+6dt4wqtZpAp
         wtkohcIWdqDBl9jWWKncH8BnACTrJ3EPC6LppTBXwCq5Fon9cIK/Sn+pU2yZ6LL0t/VL
         j9ksSqemJny4u1Is8DfSfqF0JQi/xEb5JmBckwo00xX/IC9QAogwkOMYZ4vg8CXZtdNz
         dliXnxIbe5aeJGEpaLcZwmp4u9klzXV5uzbYC/11gnYUKLaLPpRzeqpFDCEWJ9a3N0M0
         qdXQ1IDezt1A0f/UFdXIxpDsOmIBT7ydIJMAPAqcB34AgmbE3XQAaAlU0ioq38FMiBmB
         THJg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781642853; x=1782247653; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BOzw3QtUmoBO3cAElRCyupjJm7YaXn8FH12Din3toF0=;
        b=eXyzLQ7Aq5RDzojsqwoiyz9ymM6AGvOnYNfx4QG07DCh5ptOmtAYGAq8D6kTLhSa4J
         dwrGJkBF0di7H4pXNlhc3UNl4xZBEWGXdKZ6gGvCuz5iDwZ13E1QoOq+r/CsPQgadd3t
         wp5fu833FxZHps3h38TdWuu/fzwk/ik4c+WEh9JZBV3nyl9+VQRz3xEbNhdk9P3sLiFP
         1uiSKASJcNyp3RanMpQE0H2VGo0ARJQaVdy+xbPFJ/SiVQ/rZHPfi+/KDNLkU+tKJXNX
         K1XNmiiOV1jnie4Uqoc6KAwWcNxh45xYIUjiQ0ugpbxWZGF7vgiVROkoo2viSIFx71HI
         t5Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781642853; x=1782247653;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BOzw3QtUmoBO3cAElRCyupjJm7YaXn8FH12Din3toF0=;
        b=q7CuLYzglUzM05xdCOD9lVUKBPnGsFYsBrRadKP4JJaITmUq26oAAogcfmyQhCuEfb
         6KnCY2kI2sOGoTimNAubQid3l14rjFjWauNG/mD3/Mb1QFWqG2L0nDa7BvZIfCY/+ih6
         N7LMprf6Npe/P5jNp1Q+g67deu14KHG6C1+rqOV6K4F4uUP81E11Oi6meZ6CX9Bv6loK
         s55wKIm+E9pCmSb8VBuyzhOSt273EahqIFIzKICWxn/vJWgyAvf/oP9iJYtxi1GxpZeB
         lXBC9uxr4n1YpIwojmWemWGnezJo5T9DgqHj6SJ1Q7x8a7/0nvSfQBUTXwWobH52v+zg
         NaMw==
X-Forwarded-Encrypted: i=1; AFNElJ+fLfrnOTxxnDM/kFlicNtBmXAfTTKQrgf9UqHqC4xVGFhds3VhMY+O+60YEmDrDibtF6Y/sA6W0w==@kvack.org
X-Gm-Message-State: AOJu0Yz3YCS0tVIhudxSa6wkgXjA0V5WWUfnaaPc/KvX57BvPfPnaa/l
	WrTxV7+lkhLkq4zrLyjkl85vntks7y09HNOjrTfHa3W1lTu677rE1qMGz/TmcEPXxpdSZ1uVMwi
	iyWMBvsBUNKrVIYxKLKc8hNiyakrvJpEJsA==
X-Gm-Gg: Acq92OGYOdDDgLnHhq8i3v/jOx+yPcuIISh53OS0rLp0NFcZdpZChGB7jXDrxCDV/BK
	nNSqTSwJtk9lmQr4/ZAbxYPU8vmmBGAa2RajOmbkdsptQSI9TMnCqJCF8hkeOwRBIg6gNIeIlTa
	bZcP3461u36Eiz92jPmdF5UxbusZzu+DCW7fF9OMQUJb1o4fP9FQbD2Lv7WVYXQiilbDLAMl00M
	IUuRHQHS+BMKXpSgLSF49oWkW9dOB3QfSthsB8mj9M2f4/x1wZBaWqa6DSRGBa89EGjq2Ni6ldp
	WZUxk5wHb8LQkvyiqdOUxVtUKk07lk62RVMLpjrX52Z1PAPg6u03/I10zhOEm04mwA==
X-Received: by 2002:a5d:63c5:0:b0:460:67e0:563c with SMTP id
 ffacd0b85a97d-46238f9813dmr1112278f8f.38.1781641480296; Tue, 16 Jun 2026
 13:24:40 -0700 (PDT)
MIME-Version: 1.0
References: <aictKA0XWMWbxFdN@linux.dev> <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
 <aieUQUBHI+E3uNPW@yjaykim-PowerEdge-T330> <airzE7jD9UtyR17J@google.com>
 <aisEWnb3pzmVC4dl@linux.dev> <aiu06fbV7rWqY0Bm@yjaykim-PowerEdge-T330>
 <aiw2p5ANjsQUCIHA@linux.dev> <ai5y923elCSZp41j@yjaykim-PowerEdge-T330>
 <CAO9r8zOVqbJEaBqTHw=r2bYw7Lm1tO0TU9QuG+eH1rfqcTAJJQ@mail.gmail.com>
 <ajCgzNIPLhjTRSXR@yjaykim-PowerEdge-T330> <ajC+FNpkVpI4pbBz@yjaykim-PowerEdge-T330>
 <CAO9r8zMimM8n54BL1viuX3pYzO=wzQU89LhCF1HW0bAv97ZQtg@mail.gmail.com>
 <CAKEwX=Nz9SWcEVQGQjHN8P8OANJY4BG0w+iQOzoNOWuteoVjAg@mail.gmail.com>
 <CAO9r8zOD7XaJ0Uo_LLLDTRKbeTOmAwmM3q8q6rUyH3oS-X3Csw@mail.gmail.com>
 <CAKEwX=N=Umi94wdKcLxEWOqUwhz6=Lj909pc1Pr_5ivVnZmdPQ@mail.gmail.com> <CAO9r8zMHGFG_jcVeDPgowaQ2RNntp3KankwzQdgrJb9PrWu8_w@mail.gmail.com>
In-Reply-To: <CAO9r8zMHGFG_jcVeDPgowaQ2RNntp3KankwzQdgrJb9PrWu8_w@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 16 Jun 2026 16:24:28 -0400
X-Gm-Features: AVVi8CdzFDN-vHGmMQaFueNywR5at5r2sQirZ_jaY4lUl8gv53voplk3KBJ-6kg
Message-ID: <CAKEwX=NyfxfXhHESTLyirAgdVA6QaYAcam792-vSZdmo0Pz+bA@mail.gmail.com>
Subject: Re: [swap tier discussion] Re: [PATCH v3 2/4] mm/zswap: Implement
 proactive writeback
To: Yosry Ahmed <yosry@kernel.org>
Cc: YoungJun Park <youngjun.park@lge.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Hao Jia <jiahao.kernel@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, 
	tj@kernel.org, mkoutny@suse.com, roman.gushchin@linux.dev, 
	akpm@linux-foundation.org, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>, chrisl@kernel.org, 
	kasong@tencent.com, baoquan.he@linux.dev, joshua.hahnjy@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E62AB18000A
X-Stat-Signature: m7whe8gjtouxpmr4ehpbjdoopxcb1ykc
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781642854-661206
X-HE-Meta: U2FsdGVkX1/zzfN5WbAVX7nvxtkpHUHCVtpVoVAD24TxY5SIkX/pvyC76gdUHZ34RijqDDQUmBL5uZdZEtpUtRjnVJnJ53FhY0nqvdhLtsSEzH2X25yBa9VTWxQ85eWUaaYerOyT37Wr2LGiEsvVzyq/DMIy39GsFVRnH2ERt1ykgkYz23fPa4zUnH0R4HexbDipQoprEnzJa9qyQBhP6Pc8dk/zy1lEf2ZO+NyN1+VOLxuUKJrYyHWfrk+dXhMNuP8Sin4vPv6JXsoqW9cWw46i4ZFWlF9lO9GEtS/nWq+LxfOWMzZkhq+OQpE/UQ81/MRITVMg/7JjRHIj3GOK6siom55ahiaSMwGBnDFlWtkNNxbswMQwaggkOkzvd5EeG3iG+MztTFLrZ3WdsxO49Lfo2q7XJt3QmvyM6OYzAHcwH4i8nkfC1WXYhQywsoe8C+aMHbAqnXhNlCm0gJcw8ACAopoJmk8E6pRvqc/ksD+7Wb33D/UojPOht7nsk2S5Z8HG9jW5qrfAUU/PtVLxg8wnISV6gVnBC0PTBqsfSh7/tZglFWqV/yKllpQz871E+zBOrXlfr4OVVAfV+pBbjGe2h87sZzig1Kbt+td77RX6TWnwtstpCJpaJPelB5pqb7lzfwcdNa/cu4jd6vu53XHVZCe2fAuhj1ssEDclqKPaw6EeFhHrEuqWLkvPtB8YSoa6tbOqYsjC2P/hbK6B0w3Hol9VP7XPL/2vJEzAe3jqXFG9BvqRJmz0p6j+QlNO4FkO+pSoe7K4zaR/FhWmfjHmQOwjvJ1NXxmU7Rg3YXg4pUQcjAeRls+m8gXhwmRl85SqEhsynkrX2I+KOEu02JFVIw56CYj5GGkqzuot4kQtuuyabN6hfA4HWi5xj6DF1njOY/hkHZQVNYxw7Tfe7SqbLpPtj2XUaiz5B3uj94SpjBUVl2nOKqT4avtHCuZ9bpyFScyX4x/yXEI6bXO
 62GjsZtb
 I7mkX7MnP80hp69+8FczO/Sx/B8tIX+Ncy3+XG/Xamypm+dCf/znLfRpMlyF2FdKKmu3D29u5a/EzFPf8iCBGFgxWP+Iv9vx2Z8Q2Yy77tMH4QlCpZqUNJfnjyhpu5cpIo0mJd1cyoamDlihYapsahtbusmefxi9C7Xkeh+Zt0RqmwWw7lR6pU9dIrDWr0vAQatnT1w9YAXLP5C6wpd0paNN2s5TyEHGy6Fq4yGlh6fWcNxD2TUcKmmicKcuV6h/3HSr6jX0zCEk9+ujNCN6WGdOq+nMgRnU8rpGMeFyn0wo8IFKiw6rC0ecD3XMeib1oeYvqLv95SH/LHYY3QYie2UrKj5e+5fqMpQItGpFdBZqUDux+scpRzd3CpLji+J+6JKclx9tCMpCVRaKpbsZpmG+3J2y89oiUlT+XNf6Ms0SIjTO1VLMVqrAHuA9sPZqwj6Qs9g+yLCAxULvyIS7cV0TngDniKp2Zx5iw+3Ek4D931bmO8/455uNxrh3MyOWDI76PW8Ko0U5TAFLgZoK3Fspr0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 4:10=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Tue, Jun 16, 2026 at 1:09=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > On Tue, Jun 16, 2026 at 3:54=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> =
wrote:
> > >
> > > On Tue, Jun 16, 2026 at 11:33=E2=80=AFAM Nhat Pham <nphamcs@gmail.com=
> wrote:
> > > >
> > > > TBH, without vswap, we should not allow setting zswap as its own ti=
er.
> > > > It's meaningless. Maybe makes it a no-op, and warn users what they'=
re
> > > > setting is gibberish?
> > >
> > > Why? vswap is transparent to the user. Why can't zswap be its own tie=
r?
> >
> > Without vswap, if you set zswap as its own tier, which phys swap
> > device should we allocate from for the backing slot? :)
>
> Today we just allocate a swap slot in a swapfile during reclaim,
> before swapout, and zswap will just writeback to that one. I assume
> the same will work with swap tiering, except that maybe the way that
> swap slot will respect the allowed swap tiers?

Yep! So if we set zswap as the only tier, then it wouldn't be able to
allocate a swap slot in swapfile right?

Or are you suggesting that if we set zswap as the only tier then we
can allocate from any swapfile (since we're not doing any IO anyway)?

