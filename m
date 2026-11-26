Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB60D606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 17:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Wo4Ee3Dw
Received: by kanga.kvack.org (Postfix)
	id BED5F6B05B0; Thu, 26 Nov 2026 12:55:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC4B66B05B1; Thu, 26 Nov 2026 12:55:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD9816B05B2; Thu, 26 Nov 2026 12:55:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 81FD06B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:55:10 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E4D1FC020F
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 17:55:09 +0000 (UTC)
X-FDA: 85478021538.11.913E189
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3F36A40008
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 17:55:00 +0000 (UTC)
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795715700;
	b=YuY9vrDUxBxXEoXjZlKzhdbIX6eyG8v8xJboSlzf2yaPKY8JZQU83n9ytacMTpPsRwEXWi
	ZOlzUPT05eDuK+aE5dB9YqyGs9FSo5/A+zlslglIuFVC5wp2ycKMCeaGCxrXAnU0/fbNrn
	NOj+lMb9z7wQ83+vEGyzYb7fFMavc70=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795715700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SdbryK6r7Z8TT5rN4VXUmz07ho9c9oC73ihA4weajeE=;
	b=FhbBGSQfa6MVAC7ug8jDkVlWYwfdQ8lqRbUaKPsmHVRmQqhnIBvkSZBEdsrEWyjusG4qL7
	VFePn6LYCFsK49vTTfqZ3vVEdpsdPb/AocOKm8GCi6PBx5lKYs2zXdg9Awvu/Oq/wy126H
	sbK/DwXA75QbM7RjO1PtlWQkDj9yYVg=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Wo4Ee3Dw;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4aa5833c263so7032259f8f.2
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:54:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795715699; cv=none;
        d=google.com; s=arc-20260327;
        b=K+bCQ1hBfNy33AMCoF1cGPX+MRQRtuaB6fTk5vvHZfA5yoO+VwlbvG64CE5aTe1K4y
         LxftDlK1dg3M7zLPM8F+xSy6XKujEok23cbb5aRspAL+ek//di/g5+ZRExQ+uNqLnVvq
         K6JWVLSqkcSKvUaw6+jYt17Ts/qhuj9p9CzkIEyDmcoDjTtdYbG4efriyxzpp8B7b9y9
         xJw/aUoz1fPlHAxY+aKeH1ldUF+tVJa/9OYrqBjT0XmSVgrXF3ZxMC4IKbRgf5agQRzE
         CRV4Eva5JayDZWMCzYBFK5DK6MWpRRkrX2WyaWMpeMy17IU3LD3kxwRELT71LfmLfufo
         WWrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SdbryK6r7Z8TT5rN4VXUmz07ho9c9oC73ihA4weajeE=;
        fh=2qzmH6QJMmfdQ1QHfd8bds1cP4J8rnDbsyNzh7tZ/XU=;
        b=gTYwFo2BIdq5XIHVfoAdlwPapDSXb7lEaDkyixBaClDeAEXt+3ZwOV5wOisV9oHhqK
         ybM5eUaqCC7oD34+yuEuns25M1BlxU93b6CiY0Yb6ZIPFMCqzAA6446Lv/+8sTHV3bfe
         TMjAamImGJ02u+9CNF37uxAJh7RgbtOWPMfPdI6uZPehl91RUp63wWqy1X5SWyM4Rx+c
         LnIdhf6Me7wfBrSYjzOtTdKj0DYWPqNRHDe8RMQxcnyL7PxzoySBjgs6q9Ku+OKRc7LR
         K0pTJWx3HG9L5Jf+gLMd5L3M2Hq/yBClo43b8qJr4b/arFZ1mzqZc2V9G9VWfZmUQot8
         zBRw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795715699; x=1796320499; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SdbryK6r7Z8TT5rN4VXUmz07ho9c9oC73ihA4weajeE=;
        b=Wo4Ee3DwFs/nXezs3xmAu/BK5mtqqqWIcQw6QqtQfxB5zkMAcbyFBAtGXSd7eCxcNp
         HWTWD65IgLxLg8cHtPCbppBRGRrwnMpFAWMAJBYN0FFFlRgbN51vWzwoEYkFOS5N96JM
         oyiO+rY6AVIfTwP2U7FTE3hTs+j4RwO7/rzUXlTGHpKppyibvGQ2MrJXxrrdjAACD6RC
         4rr6uRhn/66XHGSMJ2OkQt3K+Mnq0n30JNGaHiBFIWR1aISUml1NYbEoPgKafA32W/2H
         /pHZXBtOdOABYPZevSMZyPJOsB910vtXD6th+gx4EeuVS5LEpvV1K+Tel1zbIYDuIqqi
         4Phw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795715699; x=1796320499;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SdbryK6r7Z8TT5rN4VXUmz07ho9c9oC73ihA4weajeE=;
        b=YzXsNLYzmQccAQ9E1NIBOLcuVx6Q2VFQB3XzI9fYLYV9Gi0zN7F8ct2tynPA2Nk/17
         xSQT4/3BrZP9ZnFbgCVZYFG8xDR5RXu3xPbyVEYGscD1QKV5IkVbyw51h9FbjLwQHLWx
         5DMEJhulKfFQmMEt0X7ra+Y0C/RwoR+XhxItFD5fGJeWB8Z36kp2pNtbExIGFS+STtYi
         CioL7PO3Tknwwuxa1RybZhnLSnPp9XJjy6w/S4XCKW1s2E5C0lh1t0Pxtyg3Kpzymm1E
         vP6reqp8bhBloTDifFma8FulNHbZtdyQ29E/Thy3y2BCwM3A8jMJSSrg0wBMzEhdhe7+
         qTwA==
X-Forwarded-Encrypted: i=1; AL+hErEBFtjPNkpvrQRlAZCUVbMTnbd9mgadszDsHTrEJkdhgA0KeSqNfcZT5kGAmudLxhCA4xUvSqOJZA==@kvack.org
X-Gm-Message-State: APuU4Z8qQNjI5XkGFZhlu2C8rXEGSBc6pD4bcoFH/61YvOrRzegxt+s6
	ZHs6fjphNnQanR8+I3g4sSd920X7Dz5t9ve3K5t78ycHkZZ076mSUQa/knGa1pvsSA1XxPQLbXu
	Rv7NAdzE5zIs1yxAW6bWzUayXcdSAi2o=
X-Gm-Gg: AZFdTZfqedwz7gBp3SDB80ULCsCQvsbCVgMcGGghyf0IOXA7cH8Uxp2JGuBix28pulv
	XTDm+/WSJYQpMSlagln3Kn5JILl28YawGbokai1cwNF2a/95Krrb9cuPFXmuSddyGgNDXdDW0g4
	zLitQleXwRFIoWBrv3n8iDIYBxMAq97ojOE9K+1cK2w/iSxYmYWnA7dTJZ1umhX3o9W/SkITpNe
	U599ZAVO+QoQSAHKC2gRkXOxlEhjZM3vc0Ev2Z/FWOOgztTUR+uZS+g9K4NXEfr2sbDrLQNIPDT
	x4xUHxCyM302whNA4h3V2Xv8mTNdvWi7mz5lM7EzPnLbE3/+Qh+ylwBtZv6AJ6epaKnSN74FpHb
	9xS0RbuYehcuAOgd0RlpcyLPxo1Brvdmb4i26SIGfhxfUr7041ieRnBz3l0+8UcgVzgVwzDkQhs
	qzfBOddK7TW94BRamfXaa1SnJcafuisZfLRI6Ca2A5aNUUNmrJS8h1
X-Received: by 2002:a05:600c:5306:b0:4a2:5ca:767f with SMTP id
 5b1f17b1804b1-4bb887c9af4mr419667095e9.4.1795715698718; Thu, 26 Nov 2026
 09:54:58 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261126094318.244973-1-alex@ghiti.fr> <98fecdf0-6409-4499-90e4-63996f33db90@kernel.org>
 <CAEmasaXWwWeuQnMbA+g8OyvNwe721Dro+1h+5pfTpzLuV6dx3g@mail.gmail.com> <0b7e81a8-d291-4cbf-8da0-e65e9a0b40a0@kernel.org>
In-Reply-To: <0b7e81a8-d291-4cbf-8da0-e65e9a0b40a0@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 26 Nov 2026 10:54:46 -0700
X-Gm-Features: Aa3M54qrITO3fdIud_o5bv_u9tR45TbGg9y25OYPa2Ghf3Ip3t8wAyWPaymBSKs
Message-ID: <CAKEwX=OHfC6gMBQ+DFPPRCvnj8QQbvEXg0SHvYqTjwrab-DjFA@mail.gmail.com>
Subject: Re: [PATCH] mm: free the swap slot of a dirty swapin folio
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alexandre Ghiti <alexghiti@meta.com>, Alexandre Ghiti <alex@ghiti.fr>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Barry Song <baohua@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Baoquan He <baoquan.he@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Youngjun Park <youngjun.park@lge.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-HE-Tag: 1795715700-589373
X-HE-Meta: U2FsdGVkX18UGCz5xZ+vdC7/vH/SH3/M3Qxi0CU3hVSkIOSY/BdwdKmiFMg8fXwbfya3LluVHuxOofFnyTg4BWNv803bJB1YYYvIF1JN890tEChi9Se4/ycPpZkMWkWTrIxo8r7j3DFqBzFhqqSpJCWkysFRM+s9OP5RXpwpLala09i0/GHhSNlFFMcmuOZqf6iwvkRbiDH8tFSYGkTlizgBifV4qgeot5wXy9yQEVTBdMgRvS9aUKjoQLzb0t5dDMU0TeXt3cFXeFq5pNpHV9XtdKyELojE9ZrvFe62KLqfwW44hRlGRweE4LYB74v6/mmfRK6ULRaVYckYMwL6P+AObRGVntQdHsGuG6WVsh/gByTuJsG9/GwKGPxkgplYK/+w4fSVzR4d2gomBFG4Sb6IYSfC4wN9i/EA19+Q5eGqlsIWRR5Edw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 9:20=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 11/26/26 16:01, Alexandre Ghiti wrote:
> >
> >>
> >> But ... isn't this zswap specific? Why do we have zswap specific stuff=
 in this
> >> common code?
> >>
> >> The comment already gives away that something is not quite right here.
> >
> > I am mostly interested in the zswap benefits, but nothing is zswap
> > specific here: do_swap_page() can also find a dirty folio in the swap
> > cache when reclaim bailed out before writeout, or when the swap write
> > failed. In all those cases, the copy in the slot is stale, so the slot
> > only reserves swap space. zswap is simply the common case, since
> > zswap_load() dirties the folio.
> >
> > What do you think?
>
> If it's generic, then the comment shouldn't mention zswap in the comment =
:)

+1. Maybe mention zswap as an example of when this can happen rather
than the sole motivation. I suspect this is a generic problem, with
zswap being a common/easy to trigger case :)

In general, seems like the whole point of caching these slots
(especially after Kairui optimized the swap allocator) is just to
avoid repeating pageout work in subsequent reclaim attempts. In zswap
case (where we invalidate the fault after page-in), that trade-off is
not worth it.

FWIW, zram is also doing the same thing:

/*
 * Always try to free swap cache for SWP_SYNCHRONOUS_IO devices. Swap
 * cache can help save some IO or memory overhead, but these devices
 * are fast, and meanwhile, swap cache pinning the slot deferring the
 * release of metadata or fragmentation is a more critical issue.
 */
if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
    return true;

so we kinda already have some backend-specific logic bled out to this
location. Maybe we can genericize this in the future :)

>
> And the patch description should be all about zswap.
>
> And we should measure the effect without zswap.
>
> So, folio dirty -> We'd need another writeback because the content on dis=
k is stale.
>
> If we reclaim swap, the next reclaim run will have to re-allocate one.
>
>
> But why is this "is dirty" linked to exclusive?

I don't think we need exclusive here at all yeah. folio_free_swap()
already does all the necessary safety checks.

>
> What if we did
>
> /*
>  * Free the swapcache if the folio is already dirty, or if we will dirty =
it
>  * immediately afterwards by writing to it.
>  */
> if (folio_test_dirty(folio))
>         return true;
> return (fault_flags & FAULT_FLAG_WRITE) && exclusive;

LGTM.

