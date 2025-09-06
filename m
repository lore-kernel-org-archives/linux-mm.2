Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ABD0CA1002
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 06:28:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5650B6B0007; Sat,  6 Sep 2025 02:28:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53C5C6B000C; Sat,  6 Sep 2025 02:28:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4527C6B000D; Sat,  6 Sep 2025 02:28:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 342A16B0007
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 02:28:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0821B97ED
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 06:28:57 +0000 (UTC)
X-FDA: 83857847514.04.2657B92
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id E26CBC0004
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 06:28:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JxA4TfUn;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757140136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W4h66ZB3eu8GQGQL6aGzFIVzFho9ZlCpR/MIbMd2vyg=;
	b=oguLXl5nwcXCEZ1ABiVTFMlRnJtJA+++Ft3enWAVx0KqZ1WQ24ULmJ4aymh9RZOLPIs2wL
	itntVxW2LkNZZp+YUTqYB/CD+/Fb2aezhEfK0gAnk6XhuKIBEFMie6099w7f/yEQNnnITz
	aQBCqnFZKXtZIXnnhHSB7YdVAEy6pBc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757140136; a=rsa-sha256;
	cv=none;
	b=lDgIy4zqQkQb/MzY3eOI8exA1JjJZkttS2dhQVXjAShX9XTvIiHx5tPWF7XnAEdj8sCPW0
	zuSyhC2A3NWhcXTCdGi5YagtNU4kvec0UC46fyYxCs/YRs2NY6NlgPwWR6jZDiRGA6D73w
	SWP+6OSQXRoPUhe1IaaiOM3oWkkRK84=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JxA4TfUn;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-61cc281171cso5106693a12.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 23:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757140134; x=1757744934; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W4h66ZB3eu8GQGQL6aGzFIVzFho9ZlCpR/MIbMd2vyg=;
        b=JxA4TfUnWf10YMCUltrmk19xBxZW2oPqpW+QuPalSgCr+Qxw2nMakESCiNScAJ7b3Y
         A0Wg+TrXnwaQYZSWUIFTYTTz5zKmU6UGH+2im1HlsJ20pORRUuowE8dhtDpoAr/7p+Lb
         5/1J3blhFq9bEvz18v4Pd+pB9s2uDDSQXl7aZYKQMyLIMpjFmpRLMfvED+SK3GM7FHQ2
         aHUsJVyQNQ0tkNuwSxAT9wOh05DXxizE0RMKhi0PYrRzb/9v4my9qd2RmcC4Q5QFOVHC
         QJyaNs2G6c8uSitsVMsCvE2sCc8qJ4ka57gTHVpxYB59H+aN/4sMLtZkVJY9QVdCTtoA
         ohdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757140134; x=1757744934;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W4h66ZB3eu8GQGQL6aGzFIVzFho9ZlCpR/MIbMd2vyg=;
        b=w/ai1q+vL0BMGrZCM1jGPV/XXhgqBA7Ml97GdA9pc9Z8GnpSuDUM1PllMRJE0FcyRP
         4CM3Ec6O/VSdJYY94Fh2yG6q+p5LR8C9VTM+yGIXPireb4H7dG4qa/KrVZybYZIent70
         tkxfJ4jhftM5mDYtBBSyyLs/bjVCKgrAVajz53bXd5GAFLqPXzhfWUgJPKEHBUgtJzLp
         cko91Ak9kSykwRccOOGx3g39PGcpSvGsTO/ztmHncJB3m3mZr48AIir8hyXU7879StCq
         ciNyML8fFDOcW0ny78ce4B/IQfrxMw6GwdGPtLSY7W4FiT0k98+Q79t1Bhy2QxTczE44
         AV4g==
X-Gm-Message-State: AOJu0YwSrWJzy5cywqjT1CUy7w95CaWxS35q6uooXn+N/O6YFOHBadqB
	Oz2PDmjyUQMN00Dt1MXYG7QeHKiTAWCbgnh57TdeEtSrZ4JR+w4A1rX0dG18z5Lwc6PuZZJpSQn
	yvgUAGcxnPL6iJ5tHOMLJy/8vNPY6YgU=
X-Gm-Gg: ASbGncu1z6llg7UmOjk6qggvNU2auOo3titkzxZwvhniiDliO6WFPv/KppmEFvn+WNU
	sT0MF4hfXG59nmIwwbMoZrvKibj/eL/P3Re2HjX8QmZaSrNjW96pf2fVEV7/MMzNlNUumNkKGsy
	qlKuLsg7mh8XdaDGE3d4oBnSRZG1ZBU1K3SAFLJSAjmbGCLJWzUIPZlpJ2rjKwqg8eJMANl2Iu3
	6eXG0KRWnmU8TtiKH1/Lktz2cFxenVw
X-Google-Smtp-Source: AGHT+IHsC2knxDQNn4giP+JXb6pHa0hvgmBiK3ec9kCE3HQZg9euXTZHJ3R19Cz2VQYbHKU+7X559ibjoRKbAKjal5o=
X-Received: by 2002:a05:6402:13d5:b0:622:b89c:d4b3 with SMTP id
 4fb4d7f45d1cf-6237bc57750mr1322154a12.10.1757140134021; Fri, 05 Sep 2025
 23:28:54 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-4-ryncsn@gmail.com>
 <CAF8kJuNhLDovRO+8Y25ArdMBVFjXnYBVjmASzMBtdsdZkQ0NLQ@mail.gmail.com>
In-Reply-To: <CAF8kJuNhLDovRO+8Y25ArdMBVFjXnYBVjmASzMBtdsdZkQ0NLQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 6 Sep 2025 14:28:17 +0800
X-Gm-Features: Ac12FXy89p0Y7o4HcvOqd96xDhUx0JrLVG0q1xhf4KrwpHZK-9I_wf8HIzv7XNs
Message-ID: <CAMgjq7CyXEy3+98JdATscgPu9b9oLbE6CM7-2pFpiQP2QrsrpQ@mail.gmail.com>
Subject: Re: [PATCH v2 03/15] mm, swap: fix swap cahe index error when
 retrying reclaim
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E26CBC0004
X-Stat-Signature: h4gsrpqkqzxza151uazae5iir3k7dbgb
X-HE-Tag: 1757140135-728767
X-HE-Meta: U2FsdGVkX1/OKrnm0ifbBwlwv7Dr1XqJUSr+cHHD/hH2CvhDt/xx/F1O/bb3e7OOJLywYbDa0tkjI3ADjDPpBOhOaVdMde6HSdQuB4lMn2/j0nyXf5Y1j85/t1pFbEhjJf0WBdM2flb9ESc5Mf/TMNDLxY+4KFNmxyMCyVGCfRtf/Woq5fef98Bt3XBPvZ08WSFdN3lGxlcqlaKCyekTN9JyjxiZLGUNmOumKV+VUX2HIlFHmjEAsLrv3Koui4lJc2fPxAivCf/Ky5FBFuIAUr87pHShtB3wLYWd8vCijvcPi2jm3EtI1jjEismSZgbAionoAu3HE1DueU4y73gdCTFPp0EnPIek8TAaOOZ4JzMOQBpls2/JzuKVgrvH8wJ2EtNRbDiEOyzoR6OudUngU0y3bERj97IlJ24a2GDxPVl6L6SCUe2TRK8iwUDmRpys+UBelICCZBY1uWxLBi4lWoX6afdZNsTdnqZ4vKq2/JH7tOD3bmrZluy83UakWJfxVnZnQ4HgV8spGxnja0s2OTzI8wpSkoHDg04BJp7BxytpSss71VCKRTnb69kdQpiJqF3I9iDhrR1tqFwiIkgrel8x55/VZfIsQ55ColsezZqBClmCXGbahLSkqBIsHHfT4Nb+rCwlP4vLmJHmEd5RGWHGyOVB65vzdB4CFjBO4Pxi0/BnZdGcsMfE2ABGacDRgRYz1JbECLaZTTNzYC7/N7YXTyRtELCow2EVhOpubexDnz2uQiAVgZ5wjCHnbUB8EN1JZaKZ8qy2/XaHgGMbTgDkjSRV1Br24mrGsRVSQSesPDp9Aa4U1hdlTkwbNWMbZPz41oKWmeoGbd0OnQfg4Wq+aPeajMJKsvmC5Jrc8K2F+rUNSAiQiRq9pPOOv6Hnbe7dgpBugHA1YVoPENx0wXpf1FmHt370jIbOhDz/6UV1TNLJiCD7LiNRPQAQuwWKVYeJyWTVenNQQi6VW3t
 4OcRxe6g
 NodHDKe1nZd30tZqVocsePC3/jf20stdFmnZzLXWDtHU6nkjL1p2jengHtGA/TMmao64iVczw40q58Cha/VvLzzpN2vKX8mktHRwv+vOsrpAUPFiYISaEmnnm+/Re6m1R2kxpAqRaGwHIQt93fv4ZMck5KSkiYrhX4YCPpeRVZVXQTC0apku254wPh9Gse1QOJsFLlBQbx2jcFj1lJGbsyaLaVSO4KIRfLQGVO2efcFCYckqBuwBNhrixFYyLF9c1qMvX9moJ17uc5EFvVeB+By326QOxkTziAtYrNnwbzq0gBdZ9i8c7CQGIRwhCqVRAAlC2JJLjRJWpBw9Y7R8AH6aOFCHPL0Qi67OfxS8gSudTi3dtOq+2/7JwUzjY3WRnn2nFomE1+Dl14ejvVrLCiLAt79vB2kALWkk9wS+pkSeOyMM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 6, 2025 at 11:19=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
> Hi Kairui,
>
> The patch looks obviously correct to me with some very minor nitpicks fol=
lowing.
>
> Acked-by: Chris Li <chrisl@kernel.org>
>
> On Fri, Sep 5, 2025 at 12:14=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > The allocator will reclaim cached slots while scanning. Currently, it
> > will try again if the reclaim found a folio that is already removed fro=
m
> > the swap cache due to a race. But the following lookup will be using th=
e
> > wrong index. It won't cause any OOB issue since the swap cache index is
> > truncated upon lookup, but it may lead to reclaiming of an irrelevant
> > folio.
> >
> > This should not cause a measurable issue, but we should fix it.
> >
> > Fixes: fae8595505313 ("mm, swap: avoid reclaiming irrelevant swap cache=
")
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/swapfile.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 4b8ab2cb49ca..4c63fc62f4cb 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -240,13 +240,13 @@ static int __try_to_reclaim_swap(struct swap_info=
_struct *si,
> >          * Offset could point to the middle of a large folio, or folio
> >          * may no longer point to the expected offset before it's locke=
d.
> >          */
> > -       entry =3D folio->swap;
> Nitpick:
> This and the following reuse the folio->swap dereference and
> swp_offset() many times.
> You can use some local variables to cache the value into a register
> and less function calls. I haven't looked into if the compiler will do
> the same expression elimination on this, a good compiler should. The
> following looks less busy and doesn't need the compiler to optimize it
> for you.
>
>            fe =3D folio->swap;
>            eoffset =3D swp_offset(fe);
>            if (offset < eoffset ) || offset >=3D eoffset + nr_pages) {
> ...
>            }
>            offset =3D eoffset;
>
> This might generate better code due to less function code. If the
> compiler does the perfect jobs the original code can generate the same
> optimized code as well.

Right, this part of the code will be gone soon so I think maybe better
to keep the change minimal, and it's not a hot path.

>
> > -       if (offset < swp_offset(entry) || offset >=3D swp_offset(entry)=
 + nr_pages) {
> > +       if (offset < swp_offset(folio->swap) ||
> > +           offset >=3D swp_offset(folio->swap) + nr_pages) {
> >                 folio_unlock(folio);
> >                 folio_put(folio);
> >                 goto again;
> >         }
> > -       offset =3D swp_offset(entry);
> > +       offset =3D swp_offset(folio->swap);
>
> So the first entry is only assigned once in the function and never change=
d?
>
> You can use const to declare it.

That's a very good point, thanks!

>
> Chris
>
> >
> >         need_reclaim =3D ((flags & TTRS_ANYWAY) ||
> >                         ((flags & TTRS_UNMAPPED) && !folio_mapped(folio=
)) ||
> > --
> > 2.51.0
> >
> >
>

