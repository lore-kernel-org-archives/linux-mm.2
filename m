Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AD0010FC454
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 21:55:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B9F26B0005; Wed,  8 Apr 2026 17:55:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06B2B6B0088; Wed,  8 Apr 2026 17:55:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC2E36B0089; Wed,  8 Apr 2026 17:55:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DEB576B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:55:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F7EF13A226
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 21:55:11 +0000 (UTC)
X-FDA: 84636744822.06.478BA1B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 90A2420009
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 21:55:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NeeK5KtC;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775685309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SHslSwDxFYmJz+2ZwRUejS0CvrNUsSr/wt9GVySUqng=;
	b=O9EjERiAWA5RqejQ0LpBZG1ss2IVKToP7jtce3aOEHT6RPrnnI4cbcvPPTYJ+shJYnRhFP
	Zz/785zLOG09yhqHNFrHPT8T0IwqMJvXswQ0XxLxAEpvaQs5WYvGQHzdDZtHZ4qeoUhxTW
	bVeNYDMY5aQgQh/rWl/2f+C1qnGZC2Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NeeK5KtC;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775685309; a=rsa-sha256;
	cv=none;
	b=Uh4uyGKfDFY3oyKUVeA2A3Hy2VpII6LgwJP5mo/JgfXhpbNWlTx6aP294zuTsPR4LHnpxg
	c46DFw47J+mVp0uAZxCNnRtJnPyhjqevmmdCfscepDPM7tfv25T1s0+fdmZzQQvuiIpTVm
	HuI6iKFc9BGKxjehQmUd8kgjDR7IIZ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DB69760121
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 21:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C81C2BCAF
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 21:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775685308;
	bh=9tyfiUj/h3G9nYoqcv1nsHUxCG2DuNBXO0qSeyZXX/k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NeeK5KtC6jdHoDdFOv1ocGFUO/QKc2/suIgnSYtB2lAPIFb/xLQ5S230iibtS7wvu
	 p93wEk29+hav4AOPEOPoe33SgLxQukMuyDDb4MeWy3DYrMeW6+JYxnuKyWSYUIsQ94
	 FtepC6YWuPozjrU0izkuQaTzGID00Q0k+Flq3JKGrjiKh71xEDjaQrES60kIDJvp7q
	 NJ5h2SQNn2GxeHrR7ypkGWDU3ytHAsrRTQHv799+3/0uDVraCB//iSzZJAlPrOS3IE
	 2jPoLOwNhnm8UjYeAluEEnIQ4GTU09T+mkiCw19cMaPqQ0RxA7mPFmZX65YcrdicDQ
	 cXyQxqaiCYaPg==
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-89cc71f4311so3508186d6.3
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 14:55:08 -0700 (PDT)
X-Gm-Message-State: AOJu0Yy5U+yI4lV2p7lZHBQuexYyfbCC+ZoGS2SSuVm+dn25NQiyLff5
	BxeQlWs1eMJhm5DKPjcfJ8hep8M6wZHKCRU5S8hEBRy2Ze5dEJVU674ziZ0305J2J7ZfX3LYvr+
	ODmIehDY8RdU8SBBIMWMC1i0HKEOKxYU=
X-Received: by 2002:a05:6214:5c82:b0:8a0:f8b7:391d with SMTP id
 6a1803df08f44-8a7042f27cdmr310757796d6.31.1775685307892; Wed, 08 Apr 2026
 14:55:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260408025115.27368-1-baohua@kernel.org> <20260408025115.27368-6-baohua@kernel.org>
 <c54e12b0-1a35-48e1-b243-991de246a8ca@arm.com>
In-Reply-To: <c54e12b0-1a35-48e1-b243-991de246a8ca@arm.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 9 Apr 2026 05:54:55 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yL3Y1Sr0MjTd6=ROC0jKf4JkCqNPODMh-m155rUFcS9g@mail.gmail.com>
X-Gm-Features: AQROBzDWRyq6ermL0Gg6O6aynt5Lhi1rCxfVFeVsKmdjacHsxC88F_qdnibnoyI
Message-ID: <CAGsJ_4yL3Y1Sr0MjTd6=ROC0jKf4JkCqNPODMh-m155rUFcS9g@mail.gmail.com>
Subject: Re: [RFC PATCH 5/8] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
To: Dev Jain <dev.jain@arm.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org, 
	urezki@gmail.com, linux-kernel@vger.kernel.org, anshuman.khandual@arm.com, 
	ryan.roberts@arm.com, ajd@linux.ibm.com, rppt@kernel.org, david@kernel.org, 
	Xueyuan.chen21@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 90A2420009
X-Stat-Signature: 8kbwj7t6ckycws9t8yump7qbbxjc7kuq
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775685309-603208
X-HE-Meta: U2FsdGVkX1+bPPoy9LQyuVRNr2F0vSTGhPnbLzh5l+DgXGnGqNWEyuHXskBrcN9elo4KXeztlcieI2z3cTTkyXCcc15vTjTLVSAtJOFiI5CKLQ4r6rPeaywvvVr1gXxjzAw7PL8SKrOp9hoHkOszw6MwtYm95H7PjU472LlJDxxi4IR2YIVAD9JHYA+sE0COCJnabbQsaSQsJCrDNwDtLIwM6105F4Fc7mJL/8WxJdd8U2mMAF4ken12Rc9MKMWW8rHpiAbpzPkg1r5ycGHjpP2CIiMo/5ao+qT0t0ctHytUmRIL5jNUTtrkbuI6xJha7BxQXmlWw+5zwSri309kr083nj8hk3depEvxFC6VpWaSIM1oP+ZMaPcGVuAxiXJ732L38Q4Y7NaMR4rbMiB6feH25uH6zahLKRWYUHbYi7yUlI0AU7HQ7EULGP9Fp3mam2jiJ5B5zMSedX0FAB+j6LxNtY+DQy3eBjx916lzjT0eR6BXpf+SdJkA+/ynqznrSwHe5/9uToP4xEMI2dE2LLQ4529zhJtyzzpxeCbNq+TFDPQ1X5zGTyp7M7HVFqyX7dMFhdRhZF+zofaJ12qBw5fUF8OFT90pQhoE1lwwWcI++ulEWsHVHj5PJoB53AjFa23f7/eA7a7E0Kjxgun9bbJgt8Mnh1ihFuwVtz0pAnU7h1MksWsH9O/+HCUDc/3h74nmlbK8smSQODOQFOsW6TR9l1BM41LcDyqv+85iHkB0QtdJdDYNJeMDB3NpbcHuGrV+oKfRwxGwkUGgxEB681KZzGmEur6IqQUepNP4xDGxFCe7+rnJxWa7ibQvb0GW0Wja0Trnf8ob4mUFzoD2d0Bj/8cHeJLcKg2kL+g7dWPEZsRL0f4hRHXh9Msp/OU509ufReB3J08PgKcKScxZ4vC2P9SaNPv08yQSKAa3+Vu4XjKKuUS5QLVhZHtvRyJK0eA4c24JDQaokNHf5Yl
 HNgRpVU4
 5FBY09mcKUa4mvoARgkYXtxFaKZXCvqtKLka4zBtEKDlAqufd1rw3FHagl5+TlNlIKCTHN/BU91WvL00zLGyrhN78MXgKto5F4QsSzhcuXToxgZsbAHLOT3n/H9wDaZmifzJew/LYRyrYgKpyu0sHnaDQgHwoDgiyyJtDsn83DNsjpPR27kzAb8x7AJGBgfPQV2+vNoKwrz8YAiGZTFq9ZfIZ7yH73tZ4JfkNwY7yanVG9g6bAZ3OeemXTdD4tSQucKXvXwd1vtnOyJDAL5CMzShovDiJnrwLBtPpGTR1I/kLCF2jBYXLbo+ciU+h8nCD+2Cloxzuiu5iVFjTnoJLNjQHQ5r8183FG8O6iSi6ARAhmo41wJhMyiMl96/Jm/e+PkXlZPNWCRte5w2bPbeIRH+lg01hcTYmVJrm+JChwaGofaV3aV0ggIBhfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 8, 2026 at 10:03=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
>
>
> On 08/04/26 8:21 am, Barry Song (Xiaomi) wrote:
> > In many cases, the pages passed to vmap() may include high-order
> > pages allocated with __GFP_COMP flags. For example, the systemheap
> > often allocates pages in descending order: order 8, then 4, then 0.
> > Currently, vmap() iterates over every page individually=E2=80=94even pa=
ges
> > inside a high-order block are handled one by one.
> >
> > This patch detects high-order pages and maps them as a single
> > contiguous block whenever possible.
> >
> > An alternative would be to implement a new API, vmap_sg(), but that
> > change seems to be large in scope.
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >  mm/vmalloc.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 49 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index eba436386929..e8dbfada42bc 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3529,6 +3529,53 @@ void vunmap(const void *addr)
> >  }
> >  EXPORT_SYMBOL(vunmap);
> >
> > +static inline int get_vmap_batch_order(struct page **pages,
> > +             unsigned int max_steps, unsigned int idx)
> > +{
> > +     unsigned int nr_pages;
> > +
> > +     if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP) ||
> > +                     ioremap_max_page_shift =3D=3D PAGE_SHIFT)
> > +             return 0;
> > +
> > +     nr_pages =3D compound_nr(pages[idx]);
> > +     if (nr_pages =3D=3D 1 || max_steps < nr_pages)
> > +             return 0;
>
> This assumes that the page array passed to vmap() will have compound page=
s
> if it is a higher order allocation.
>
> See rb_alloc_aux_page(). It gets higher-order allocations without passing
> GFP_COMP.
>
> That is why my implementation does not assume anything about the property
> of the pages.

If you=E2=80=99re asking about support for non-compound pages, I think
that=E2=80=99s fine. My current use case is dma-buf, where pages are
compound. I recall discussing this previously with David and
Uladzislau.

If you=E2=80=99re working with non-compound pages, I=E2=80=99m happy to add
support in the next version. I=E2=80=99m also happy to reuse some of your
code and credit you as Co-developed-by if you=E2=80=99re willing. I actuall=
y
prefer your __vmap_huge() name over my
vmap_contig_pages_range().

Does that make sense to you?

>
> Also it may be useful to do regression-testing for the common case of
> vmap() with a single page (assuming it is common, I don't know), in
> which case we may have to special case it.

I agree, so I had Xueyuan test single pages and highlighted this
in the cover letter. There is no regression: "vmap() is 5.6=C3=97
faster when memory includes some order-8 pages, with no
regression observed for order-0 pages."

>
> My implementation requires opting in with VM_ALLOW_HUGE_VMAP - I suspect
> you may run into problems if you make vmap() do huge-mappings as best-eff=
ort
> by default. I am guessing this because ...
>
> Drivers can operate on individual pages, so vmalloc() calls split_page()
> and then does the block/cont mappings. This same issue should be present
> with vmap() too? In which case if we are to do huge-mappings by default
> then we can do split_page() after detecting contiguous chunks.
>
> But ... that may create problems for the caller of vmap() - vmap now
> has the changed the properties of the pages.

I don=E2=80=99t see this as a problem at all. Splitting pages does not
affect physical or virtual contiguity; it only changes the
contents of struct page objects, not the PTE/PMD mappings.
For ioremap, there isn=E2=80=99t even a struct page, yet the mappings
can still be huge.

Thanks
Barry

