Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0E7CCA5FCE
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 08:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4926B0096; Thu,  1 Oct 2026 04:09:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBB396B0098; Thu,  1 Oct 2026 04:09:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD0FC6B0099; Thu,  1 Oct 2026 04:09:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 485E66B0096
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 04:09:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 32CA340324
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:09:40 +0000 (UTC)
X-FDA: 85273333320.01.8ACB6FF
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf21.hostedemail.com (Postfix) with ESMTP id 47F7E1C0003
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:09:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r1mDQ0pg;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790842178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7WUeRXQIxnR9XpkkjIeWQnzVeCWSoXoruQ6cCNl/Q6Q=;
	b=aqUxBUsQXSD4+ZtU/xEWAS6yx4g6c7Mf/XnTNhFXPA7WaIneA+MGpsllvNH8mxtA5zFKpp
	VSyfHoz+bbmO1FhpbJyo8lMWuLfOXiQJ3GHoJX6QC0ycDkza7QY4Vro6hCWA8LCt58fmBY
	LdBAV0sDU1XAyhAxWfIUrLm/qJ17iDM=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r1mDQ0pg;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790842178;
	b=gVyMZMeZKkaY7dTroi7sOBREv4fwVI9TiNgLrJhUhnAiqNQ/mfKJsfTT2lIqvsQnFhYAKW
	CEYXbRxj9sY4c083FfXQgV5RqOAWMNJ6gq2utJu0SAzxhlFyroGMYjd0g7l/7dBSJuhMll
	II31hfsi+tqCQGUfvRrCCJ18n/phdyg=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4834977ae75so3798406f8f.3
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 01:09:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790842177; cv=none;
        d=google.com; s=arc-20260327;
        b=ZcCozL2/09j33SC2kC2QIjcsRja6ADPRrAj4lTKeWa3pL+ygx/M6bUhNHUBzLex2cX
         TEJBsWqBqdORYJA44O3usIXaYjYBCuF1V6ohmceqf0uvJOUUjDSZFv8N8aUC3oOmjEDK
         Q2R02e1moxZeCvrvNDWZV7CrnnZtKravENqIq7N8awHqm9UEveq/DAiYn7VkuzRlVLO5
         HItFZEAoExZoHEIOcHOcDjXKwncQ9chfbd/pz2Ev7+/YoCEKjuJDLCxNBwvERuDsH6l/
         MJaRO9kP7nNNtE2PeGoeNToQVxLdqwOx897WItEgLdtU7TMohShNF+g2koD0mMtb2xZV
         XQNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7WUeRXQIxnR9XpkkjIeWQnzVeCWSoXoruQ6cCNl/Q6Q=;
        fh=pnL8SprAH4ynKh+FhTGtxIbDF+QaQJEgVPSiw83XiuA=;
        b=msRev4UKEfivSkK5J8idTomGUXPhVFOdgQsnwvFtdk99MCou6F76hBBaM89D3OcpM4
         muVtZSkQWJ/Bz+GZ/K7+SGg8JyUImh5z1NHSTo8R+2izO6NZh/fY+7glo5bKEU0Pn73W
         HBlHVNFCE2vbBT4HnfwpjWPzoUkdYtq/FPHCV5EOy6RGl1czUx2OWX4Rx7EC8MZ6OQ0N
         rKuAVuhBRx3PHSgQmnOeAGU1LX65Q6igg0qfm+vRFBWkN2ciZhnbNjw4M9KumZb3vggi
         RXsRIhuarV7fgj2Zhi6XHOPdO9I+3gNv4sd7U6vrvMZa5UEjO5YYB0CqNLOt+i8urbKe
         ivAQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790842177; x=1791446977; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7WUeRXQIxnR9XpkkjIeWQnzVeCWSoXoruQ6cCNl/Q6Q=;
        b=r1mDQ0pgjvP9Sf+HKIwIQ/k2wGQipqDRB4LJoDPANCJGiqc7EWNZd9QPRrl3W9rkuL
         YULUp+JvWyFM8Bg6+z7CBoZ3xq4eN9yHGkG12tWlhoODD9bcbZ4L9c488c+/hsc95ALk
         XmiprEY13Zt4iup30BB2xCGzqIdu1nLazS0L9NLCt3JBd1BIOX+VbPPw7eksBV382va6
         +rEDnMdVgcBpsVn0tIYJla7y30NpokX6B+apTESlUrKFa/86YNKrc46srMB1hbB/zaCa
         3CHHSbygyZVAgna/T/KTRyyk0Xh6jUvqgf7NoYmdHM1rvrWUvqmrgNTdz5wy2nvta0LV
         1Xlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790842177; x=1791446977;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7WUeRXQIxnR9XpkkjIeWQnzVeCWSoXoruQ6cCNl/Q6Q=;
        b=mfjwdNnSqVLO2g3yk59jO8/aESGgpVqfjFLSj/58FsqrLf24l7Mhtmy9dqguc1HSpK
         3WyPzi7UlA3GQWdhFHiSTEhp+1RF8Ik4U56REFIgYWdPkBWMwr1W6Fl+yR/PAwSponbf
         FbRU65rA0BCDjoFhvlQyxju5uv9nSEp4lo00VTD77ePH6L2O6FJwNOthvNeluxiOy8pn
         ZcNVfW3JxhHMnoYBJYfHHEB8jpLwXju9xmCe51KTDq37CraoH2QncynKCwKzHagFCUte
         8q+ULf9V14XPmwXuXh9CCte8OzBV+y7ZIIxb6fyReHGRtFzzP55Dr1PGmmr8rpcG2PNR
         Lg7g==
X-Forwarded-Encrypted: i=1; AKwUvBzC7hz09iKS3pzz4DGZcYOFxrtCVWE2dV2+5oZmHdMPm1N+YFjtmSaIN9WfjlRd5Zb1lPRCoFOesg==@kvack.org
X-Gm-Message-State: AFq9FYLANSaNxzOmyyKhpAAjoq0DgE5d30H6L+Wu1N3dudikT9jrlG39
	zEl2DH67O7OId51UB0IiyzboaSV7IESLh3F+LGhFvhHdB0PfqjUErOoj/QebNZ/le4H4AfErfwd
	4f2IUOD86aG1gFi0Vgfq+1xpIp8/0XqtOQh9J
X-Gm-Gg: AYBFou1/WKDCPqIuHcxzF+i4xOY+qLEgsnO1BU3Bn+C11qCOajGIFeBuJ2YWni6Kae3
	4aMgZ1TfJ3pF2H4YSn2XP7tYgstt0W+eCIYK2sV/CTVwLJ3AZLUcv7zFk2CByrn0fC1brRBSSf9
	o+z944XZWbfCLpmbY6mXfwaAG3VKJ/HNe9f7o9D1tUUmQMPCYN9NF3pvNwDgu1gnm3GbazXp0w2
	NVn7WHg/pgd9wWpuUZaVkkOJyU9uiCyTrJ2KnjHLliqoqryQELsjGFPgIZC3oj8zlwlwl5WBWeK
	Y97fpE/8d4EcdA+3yj4UC4bruMmpNw+3+DOSGtYuJpLHoaHXUNvcN5zD
X-Received: by 2002:a5d:6f0d:0:b0:48b:677:f80d with SMTP id
 ffacd0b85a97d-48b0677f9aamr3770293f8f.26.1790842176618; Thu, 01 Oct 2026
 01:09:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260923062832.479455-1-jiangwen6@xiaomi.com> <20260923062832.479455-10-jiangwen6@xiaomi.com>
 <ar0lMkKxugZV7xyw@milan>
In-Reply-To: <ar0lMkKxugZV7xyw@milan>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Thu, 1 Oct 2026 16:09:24 +0800
X-Gm-Features: AclHuK8OMAhb_UVj1_7OhXb2I-BHJ5VHW4np9K-mqeZSCcIAGrWhZjO-kRMUNUQ
Message-ID: <CAHKocdEqnCCyW1TgmiRotFO0hQdHt7pXP1sdqzZ7Up6wc+-Bsw@mail.gmail.com>
Subject: Re: [PATCH v9 09/10] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
To: Uladzislau Rezki <urezki@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, 
	will@kernel.org, Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, 
	anshuman.khandual@arm.com, baohua@kernel.org, chleroy@kernel.org, 
	david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com, leo.yan@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, mpe@ellerman.id.au, 
	npiggin@gmail.com, rppt@kernel.org, ryan.roberts@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 47F7E1C0003
X-Stat-Signature: ib9tye3zsdn71kgxiwiaf9d6jpty5k7y
X-HE-Tag: 1790842178-879026
X-HE-Meta: U2FsdGVkX19BzYFKhShD8BEg3SOmwsgVohcvKTlu9zuCEuWn1H7f7/dRuAcjlxVekd5dPg4xtZ2ZE0qYrmdkaf5V/w9vUvz8zeBfVQCoOl1RQvQJ+EbN58SEnQHLGST8rPLf0Q+ejnRndx8uaPrkLixLdOS/79npPWN7yGkw1fxjefA8o1sGoURtbnkFUurrJ+LGWcYxBFoIjAteqxLds/3V092x5MKYOcqg/wJ6zwDgDFMeStwvWEuZ6cNWs95zMY33zqx8aqpd08GQUGMj7SdSV2N6Azoj/EZw2crH6NKYumbXCX6aBq5aFD9Bmc5a2rOL4JxCo3ZCn4HnH8ec7s5oEoSjP/LchHWul1M4yZgH/05SVQ6Nibu6xXN7U/XdXPMTUAzg2k6LBvTncTW0KcOp8WMc2l1EV1PnGzBmRY633gLqcl+1QkPcAh4fYLt72mI0QgSPEq8kRchXOILc9ubDXc76fcAoVEHEDHthfpJnF3LBvd3Ve96GIsmwEFKcL4CKkqhC7uw5LTIq2Ok2RJYk9A1RGlvTSRLFaXCwjreElwmUOvM01m3uOGwr9YTb2NdhOaXdFyTcRujxHYpHtTrrDkGL/IS+KkIpmiEApxJIaWHsXX5FUQSNclTKdTXCdfFpaFoMWiM8uBmqZxCJ0FliUe592x+iBn5H9OdslqvwI9NyEOaeCyItUw3NhNHRV7JpEsvmKKe28tbureOFuC2xM3ExwXaEq5XJj8duDhBGllWBpO9GWM/Mudpwz/+AcUKypJibsVBsc0J1ThTWF7puHQqXURu2cXlHN+Ctr4LmwgVIwWucs+9ufrYZ5RW/BwgAO9wHQ1qaIMKZkvLiXdo/Ea/R35+U1Vk7JnEbGOBER+w3hsoW3Z7tdjKGkqzEmCtwlLWlbPJoDiE1CMMLdDZjNlZnZobR8gfJh62Kg6UItjLJYFd8J3YtwmfsYn6c0mPR7xrSVzEx25cgDF7
 YVj62WAO
 meyT7TucBce3qBfz60LxlSKvICFjcQCfuR3ues+UuRbTiQI2emwDL79QaF4bztQkEaw7FSr3lDf8pOphlmbLyVIMg08SGXDrphB75jCtEdwv5dqulBrDHyrBAEpUEA9Mwfsmoi5XcmTUtC6f2p5i3dXg6M65G4NMq5NHK/FWtLA7kGcBF/A+S55zcjQG1zlq7zQknEHk7UV+k/ZddKbOqac4PiVa9IHme/fyhQO2wW794BxVkdIrOayWRTX2GSXdVA5YuWTcDSfTuEDSgXQD6DQXhi+7FNzfZ4Nz/VgvGQu/4+aXeE7XmtM4efLxAhksX/y1E0JyprT7bx7TYedwhY3MapFS0WlCLrwEs+9laPWGDHXEK0I1zau5+lCHHVFGvOyABG7Yfvf/7xbXBNXMQ2tZxQrPwE7+Q6jMGhCQ0djhc+M+ph6KmxKDmFfsUkmKRbwAKqgmHs07ib/7Yq9HPDl2w1iJmCBVGXGY7hx3FtcGMpUlW37X8xg5JsFNaY+vwkR8GruxxMnRMJmT+jsGJpRZtflpVzuiG6GK/DQWA9KFQfk/QWw3La2KbnQE/WdZ+90si3GZleo5n8Q6Rl8wQqOwWmTGwBdZ2DUJe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Sept 2026 at 23:05, Uladzislau Rezki <urezki@gmail.com> wrote:
>
> On Wed, Sep 23, 2026 at 02:28:31PM +0800, Wen Jiang wrote:
> > From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> >
> > In many cases, the pages passed to vmap() may include high-order
> > pages. For example, the systemheap often allocates pages in descending
> > order: order 8, then 4, then 0. Currently, vmap() iterates over every
> > page individually=E2=80=94even pages inside a high-order block are hand=
led
> > one by one.
> >
> > This patch detects physically contiguous pages (regardless of whether
> > they are compound or non-compound) by scanning with
> > num_pages_contiguous(), and maps them as a single contiguous block
> > whenever possible. The mapping order is determined by taking the
> > minimum of the contiguous page count and the pfn alignment, allowing
> > graceful degradation when pfn alignment is less than the contiguous
> > range.
> >
> > Pages with the same page_shift are coalesced and mapped via
> > vmap_pages_range_noflush_walk() to avoid page table rewalk.
> >
> > As users typically allocate memory in descending orders (e.g.
> > 8 =E2=86=92 4 =E2=86=92 0), once an order-0 page is encountered, we sto=
p scanning
> > for contiguous pages since subsequent pages are likely order-0 as well.
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > Co-developed-by: Dev Jain <dev.jain@arm.com>
> > Signed-off-by: Dev Jain <dev.jain@arm.com>
> > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > Tested-by: Leo Yan <leo.yan@arm.com>
> > ---
> >  mm/vmalloc.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 80 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index a43965016eb4d..37cddb7f45a4f 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3576,6 +3576,85 @@ static inline unsigned int vm_shift(pgprot_t pro=
t, unsigned long size)
> >       return arch_vmap_pte_supported_shift(size);
> >  }
> >
> > +static inline int get_vmap_batch_order(struct page **pages,
> > +             pgprot_t prot, unsigned int nr_pages)
> >
> get_vmap_mapping_order()?
>

Agreed, that's a clearer name.

> > +{
> > +     unsigned long pfn;
> > +     unsigned int nr_contig;
> > +     int order;
> > +
> > +     if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
> > +             return 0;
> > +
> > +     /* Limit nr_pages by pfn alignment */
> > +     pfn =3D page_to_pfn(*pages);
> > +     if (pfn > 0)
> > +             nr_pages =3D min_t(size_t, nr_pages, 1UL << __ffs(pfn));
> > +
> > +     nr_contig =3D num_pages_contiguous(pages, nr_pages);
> > +     if (nr_contig < 2)
> > +             return 0;
> > +
> > +     order =3D ilog2(nr_contig);
> > +
> > +     if (vm_shift(prot, PAGE_SIZE << order) =3D=3D PAGE_SHIFT)
> > +             return 0;
> > +
> > +     return order;
> > +}
> > +
> > +static int vmap_pages_range_batched(unsigned long addr, unsigned long =
end,
> > +             pgprot_t prot, struct page **pages)
> > +{
> > +     const unsigned int nr_pages =3D (end - addr) >> PAGE_SHIFT;
> > +     unsigned int prev_shift =3D 0, batch_idx =3D 0;
> > +     unsigned long batch_start =3D addr, batch_end =3D addr;
> > +     int err;
> > +
> > +     err =3D kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
> > +                                          PAGE_SHIFT, GFP_KERNEL);
> > +
> > +     if (err)
> > +             goto out;
> > +
> > +     for (unsigned int i =3D 0; i < nr_pages; ) {
> > +             unsigned int shift =3D PAGE_SHIFT +
> > +                     get_vmap_batch_order(pages + i, prot, nr_pages - =
i);
> > +
> > +             if (!i)
> > +                     prev_shift =3D shift;
> > +
> > +             if (shift !=3D prev_shift) {
> > +                     err =3D vmap_pages_range_noflush_walk(batch_start=
, batch_end,
> > +                                     prot, pages + batch_idx, prev_shi=
ft);
> > +                     if (err)
> > +                             goto out;
> > +                     prev_shift =3D shift;
> > +                     batch_start =3D batch_end;
> > +                     batch_idx =3D i;
> > +             }
> > +
> > +             /*
> > +              * Once we fail to batch pages, we expect to fail batchin=
g
> > +              * for all remaining pages, so just give up.
> > +              */
> > +             if (shift =3D=3D PAGE_SHIFT)
> > +                     break;
> > +
> > +             batch_end +=3D 1UL << shift;
> > +             i +=3D 1U << (shift - PAGE_SHIFT);
> > +     }
> > +
> > +     /* Remaining */
> > +     if (batch_start < end)
> > +             err =3D vmap_pages_range_noflush_walk(batch_start, end, p=
rot,
> > +                             pages + batch_idx, prev_shift);
> > +
> > +out:
> > +     flush_cache_vmap(addr, end);
> > +     return err;
> >
> On error, if kmsan_vmap_pages_range_noflush() succeed you do not do a
> proper cleanup?
>
> i.e. to cleanup KMSAN metadata: kmsan_vunmap_range_noflush(addr, end);
>

The KMSAN metadata is cleaned up by the caller: on error vmap calls
vunmap(area->addr), which reaches kmsan_vunmap_range_noflush() through
remove_vm_area() -> free_unmap_vmap_area() -> vunmap_range_noflush().
That is the same contract as the pre-existing vmap_pages_range() path,
which likewise relied on the caller's vunmap() to clean up. So there
is no behavioral
change here.

Thanks,
Wen

> > +}
> > +
> >  /**
> >   * vmap - map an array of pages into virtually contiguous space
> >   * @pages: array of page pointers
> > @@ -3619,8 +3698,7 @@ void *vmap(struct page **pages, unsigned int coun=
t,
> >               return NULL;
> >
> >       addr =3D (unsigned long)area->addr;
> > -     if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
> > -                             pages, PAGE_SHIFT) < 0) {
> > +     if (vmap_pages_range_batched(addr, addr + size, pgprot_nx(prot), =
pages) < 0) {
> >               vunmap(area->addr);
> >               return NULL;
> >       }
> > --
> > 2.34.1
> >

