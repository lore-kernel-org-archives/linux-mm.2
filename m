Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E2B0CD6E75
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 23:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA7B16B0005; Thu,  4 Jun 2026 19:56:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B58B16B0088; Thu,  4 Jun 2026 19:56:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A47276B008A; Thu,  4 Jun 2026 19:56:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8E3B06B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:56:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 21E57A03B6
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 23:56:38 +0000 (UTC)
X-FDA: 84843892476.11.42A5461
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id 172E8C0008
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 23:56:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IapdqJVf;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780617396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tTbBsUwHHm3SfLBan5a6Nuc5JlHgCbloUDANxbT9zzE=;
	b=7qV3p81zwRuwP+oz9+Q7GlK0/PLGApkZ5ECp9j0dEON14IELcsiNMLDndoqHaykF/XOJ2+
	LokGNyWUHkjSQTn6XU82p2iIef0nLsnB3Z74kFerUcDKePPuQN/EoxaZYW0wkbLeVrrU19
	y5+W6vBzh6NOfj9dWJ84vAH7kqtgTi0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780617396;
	b=JiRocGzui2oTLHvof5wqwqs1uZPzYbug+oaZWrNi3qDmCrW8zDLuNC9ys/RTDf1+ckwTRr
	O2WYxvlxu4QRJnz/uDevjgIMRow7OufkQ1VDbxPHY5NH15FSJ/sn3x7TdjNS1sNKB4bcz3
	BJgQv1PHjqbav6i1e41nPDZPtbX8DbM=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IapdqJVf;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51765331535so131001cf.1
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 16:56:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780617395; cv=none;
        d=google.com; s=arc-20240605;
        b=g/5L04E6yelVXJ+0F15sW3or6lzRbo6VJvjWsZZZTMhVYulBaY3R3BRc0BEM+btiPR
         sJSa8rHzD8YkbSj+xpzraHd0NEDvv3C6NjJmoEvS+DaiMx9LOE2IY1wGQeu8N+n1+7s6
         adjzUnsJJGjx1YPhFiWEcyQ+74dLL2fYt2i0JIz87CZMkhlpn/2omc79m7yuG9lCYuwg
         BD+4uE/XMfmn+YSSRKKFgJgfZ6uNpuFfgwvyK56VFp3RxUGhpdtT75SJ9G5Nv4E+yK7D
         0G9E70Gng2VzFvAnZFZ8j/yKX7ZmDnqw5o39BSLl6LjOkAvGBR2bg8GDBg3c8jOCH1IG
         3DFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tTbBsUwHHm3SfLBan5a6Nuc5JlHgCbloUDANxbT9zzE=;
        fh=02EPAuqmdNmJuOoSMgoZZjJlZy/OHbXy61sAkLjcCK4=;
        b=AAKhYTUcMtib1+G+mEsEZmAK1K7nl44zyWj3YilBYE8nlv5sY6CbxLgLhYSDSWnBkx
         dr1gqS6/C7DCqxKl7wSa4EE5fQZAx+wPUf80fywvYmVnOZH+lv+/hy0pgqR8FQFC6aAr
         Xbv9gZ1CvpH5oBR5OgxlusUXYdw00+I2RNGhKy1GIbP6jvLkUPKGD03vO0OvtpB8nehJ
         ss1DuMBgDlKH61AKJbkthhjIsJT8ZyfObyXSMZrZDnMrkKVSJWcZm9XWVshrrc5iOY7b
         U61iCca4MgdJqTp7yqc6abZRKajnnKMUQKi6XJTxBqbe7Sylgl8Coc7pMAN4aZyVLtag
         VKbg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780617395; x=1781222195; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tTbBsUwHHm3SfLBan5a6Nuc5JlHgCbloUDANxbT9zzE=;
        b=IapdqJVf+EeI6rXfNRj41/RaZOCBFtDbaeXOpQPl7m0QSkIIQ7Tw4SKkru+UZk3ecq
         4qPWaA68vVHIhmytTMFV6W6lkQr7J9NUjuhz1yNn3w57YmG49kh0To2+l3EAE9Qigds5
         JLNI6ef74kEJ+HKowh4JxU3c3kApiaPJHz5pNaPgGMSEdvPD2z1eCQwjfTZMLiH/L+dR
         NCrITK0KEsr+rk/9u8dJ8HFoi33ft9WVjX8PzkTE4jRDNPZ7WFo12k2tvAn1TR+SUYBq
         1gnSZfstiBw75Z09QFYQNH2Zo4qIuWC0w82AOsUA/ze1/FhhvHamzllRkCAkCkpThK+T
         MOjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780617395; x=1781222195;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tTbBsUwHHm3SfLBan5a6Nuc5JlHgCbloUDANxbT9zzE=;
        b=sxC3oe93W1S6O/v9dj2/6zP9HO8h6V3bo3+4LBRc0X/BbypFEyRjiXJ87AoBc9t9TV
         WBG1KNcikK8WkMwZTXAqQ2wtQiMY3QIg90UTBYxgdCwGT2LA3/ruNaJgj0ZMJB72sEUE
         6v3EQLKmuZc3/2rGqcxFgPlgLGoLvEQYwLmkdROy+yImQI/2tGJyHday0vD2Mw578sEC
         5e97hQ7v59g5Lx4ujN9p467qfi8/hAmNbPK/Mo39kUdtnFl0RoEGg4U7My8W2fWL0H2H
         wGej7VKwdqmesv+uKM7ealGCil3yLqT97nX6VUHDfnAyAXGcbmH2O/EniLwRlhWDx75t
         U3cg==
X-Forwarded-Encrypted: i=1; AFNElJ+TWCRr/fSe1Oc+6Z+4SyHDAgSzIPzrvh0MxeXg3y+natj/tPdKFDcUjQMsq9/A969i0PfOZctdZg==@kvack.org
X-Gm-Message-State: AOJu0YzDgUr+KOFdfHWZPtMUd6zVdFfCinaiaMActhpR2i25KLy95wwR
	HjVJ5BXaWWEIy5bZyQVAPHcOWthhD36y6yQ5asJaQmOHlNaLgtxawNVBAV+0UbPBB402jqFlmkS
	SspMs+aozO3EKkm/gYZleRg66YlBiButGzhGYvu/S
X-Gm-Gg: Acq92OH2hTQUXvZFCUBJHHswnMHkslPjGNXBi9K5Ix+nTEVpoI9d1YE9NMkwdbLc9YB
	cwQrj/ta8BiHBL0ooJgIAisaUKD9W74Bb3KD0Hvbq2WT6vOF4Nv/5Hrirpl4RMxBmmdJ1AVe+0W
	nio6/WRemHv8nW9sIwu++7jiHCrK4BR4OZV9M6JC9MptjYdcHIYfEXMtz5iwTT6c7hBjgPE3w/c
	/Hf8kz8Az7f0BpM+PbepYj52OyobJDwB2yXtMFCIooCQxzYQGzGtbvSMhK1GKL+Q3UgKqnzVyjT
	E1dCOcsSlHPJaCV3
X-Received: by 2002:a05:622a:a10:b0:517:6010:7c71 with SMTP id
 d75a77b69052e-51797ffdbd5mr1473801cf.4.1780617394531; Thu, 04 Jun 2026
 16:56:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260604024008.46592-1-hao.ge@linux.dev> <77d12ac6-0a0c-4d1e-8fed-ac59b519fe28@linux.dev>
In-Reply-To: <77d12ac6-0a0c-4d1e-8fed-ac59b519fe28@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 4 Jun 2026 16:56:23 -0700
X-Gm-Features: AVVi8CedoBvarsPN8O1nAQn60jm_ZqXLYYumTl-EwDmlsfPM-d_7cOfCQprypS8
Message-ID: <CAJuCfpHjf6wpgwpHWf2gOy2Q06EWUo278817_hzLyxzMeFrS+w@mail.gmail.com>
Subject: Re: [PATCH v6] mm/alloc_tag: replace fixed-size early PFN array with
 dynamic linked list
To: Hao Ge <hao.ge@linux.dev>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, 
	Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 172E8C0008
X-Rspam-User: 
X-Stat-Signature: yaphybxwy8jjgh3tp46uo6gwbh5dimu3
X-Rspamd-Server: rspam08
X-HE-Tag: 1780617395-845336
X-HE-Meta: U2FsdGVkX1/AxXy5LoPaxqZaPzZYVuYyk53iSeMh1hHsMJWoq6vEFR58EZ4oxtFXYPbS0ixyymBZN6qJTHtqqRcx25969rSp+1hgoYcJOnJagBitXD5gEA0XZhXDE5cIj2Y6Hxg+Ld63WjSrO0Z1WXQn/AerFAJs+6Iul/Wy5g07iFLgf+O95Zaj+WJOtctyfodaeGQU8tLJ+3/z+2M9ZLVbFEeUFOYGnacVI6qHXj5MHdSGGUweJi4V17oPhTgfmDCiAu6CatUgfW7udxcPG1RrzttnaejvnRsTiXU0bmmolw9yW47ETEPKedtqfG8qiKtD8FXPP8W9qOffLGVEErNZ2DNf5KyLO9hpIcTQ/gN/9dfMqu0/4YL3WEWh4Z9U7fWtyxfrxgHL0e2u2n8aUlraxqVTnOdspnTOEm2qNq+p/mrrKFEg86GupWHFCtSDWCpb+VHGkTkILGxHSLCoN91DuuKW30m+mPNuh9suGAAuU7IdoFt/Zr5c9nFyqN3WGKtx4Ih59w0JfjO/qXe4BesF8DxwwYTELJJX8MAYvZf0CdeJzcUq90qyVndJtpgMvUfZpl+6Fjw7RaHFWeZC7yT5SUQ4Pdq5+tXjXAuqNUhKPNh8v8ayoV+zXy/mhmu/5bGs+hJzqTsbvNq3Wvuwar7UyFysWtafbICII0xxzep1cXS8tO6DmkCrozZ2qdG/Ls5Ti+c8G3vURGO0/g6OBf7hJedl4IVo7C2/lRC1yT3fpGR9pL6V0oe70cqYgnoYbCWiMux5orotF7g8cjc4jLFcU0Rk6f/DuMOxKFWdVoTF6gUwW7/vBIozFkkmt+/tWiiUzyHoTWEB7KN9PmV/gNsYVfTVfC96A4Zaaw8Yei/RQPirog/8NK2OHZ2D1uRovvNdFwXvE8tzIG0XcoQHMMlbeOIbaoiRmXg/P1qgCuzwqpGxb4344ggwT7u8mP8Bood+UUwBTOjsw1y398f
 Lzv3tZRr
 PQsdy8B4Oqqzp0XkqScjuN9N0sjNYHCcfmNhe0m/ReixWHXFCpJ+2txnnegPY5l0XsPkn78xu9NSk4OU8YbMIqqoAMPOkUAvTlfLvfisladmVoUQiLqv3fj7MuiMDIlru7MP5pWjO1zBV0NxUDTudZoxKRzx9B93oLjX/F1WWPw8K+7DwrybyQH4y8nzBkeaqbSDF2pqmvomCiDoVdaSRY/lKwTeQaXcWzlWAVlAt7A0zYrThO/QCvHnTKx7OHDXe1jgdn8tk8k6S6s9TO6WQ+/0KPMLMQFNvyz2sxFquEp+rht/KC4MP2tzqe/AOuEkqyTSBd8pBJHrck4JmotMbpBfRV7qmfBBN+YJP7kfAkb64Xe8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 4, 2026 at 2:59=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
>
> Add cc:linux-mm@kvack.org and lost part of the changelog
>
> because of local Git environment glitch.
>
> Sorry for this.
>
>
> On 2026/6/4 10:40, Hao Ge wrote:
> > Pages allocated before page_ext is available have their codetag left
> > uninitialized. Track these early PFNs and clear their codetag in
> > clear_early_alloc_pfn_tag_refs() to avoid "alloc_tag was not set"
> > warnings when they are freed later.
> >
> > Currently a fixed-size array of 8192 entries is used, with a warning if
> > the limit is exceeded. However, the number of early allocations depends
> > on the number of CPUs and can be larger than 8192.
> >
> > Replace the fixed-size array with a dynamically allocated linked list
> > of pfn_pool structs. Each node is allocated via alloc_page() and mapped
> > to a pfn_pool containing a next pointer, an atomic slot counter, and a
> > PFN array that fills the remainder of the page.
> >
> > The tracking pages themselves are allocated via alloc_page(), which
> > would trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() and
> > recurse indefinitely. Introduce __GFP_NO_CODETAG (reuses the
> > %__GFP_NO_OBJ_EXT bit) and pass gfp_flags through pgalloc_tag_add()
> > so that the early path can skip recording allocations that carry this f=
lag.
> >
> > Suggested-by: Suren Baghdasaryan <surenb@google.com>
> > Signed-off-by: Hao Ge <hao.ge@linux.dev>

Acked-by: Suren Baghdasaryan <surenb@google.com>

>
> ---
>
> v6:
> - Use hardcoded __GFP_HIGH | __GFP_NO_CODETAG instead of inheriting
>    caller's gfp_flags for internal pfn_pool page allocation.
>
> > ---
> >   include/linux/alloc_tag.h |   4 +-
> >   lib/alloc_tag.c           | 140 +++++++++++++++++++++++++------------=
-
> >   mm/page_alloc.c           |  12 ++--
> >   3 files changed, 99 insertions(+), 57 deletions(-)
> >
> > diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> > index 02de2ede560f..068ba2e77c5d 100644
> > --- a/include/linux/alloc_tag.h
> > +++ b/include/linux/alloc_tag.h
> > @@ -163,11 +163,11 @@ static inline void alloc_tag_sub_check(union code=
tag_ref *ref)
> >   {
> >       WARN_ONCE(ref && !ref->ct, "alloc_tag was not set\n");
> >   }
> > -void alloc_tag_add_early_pfn(unsigned long pfn);
> > +void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags);
> >   #else
> >   static inline void alloc_tag_add_check(union codetag_ref *ref, struct=
 alloc_tag *tag) {}
> >   static inline void alloc_tag_sub_check(union codetag_ref *ref) {}
> > -static inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
> > +static inline void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gf=
p_flags) {}
> >   #endif
> >
> >   /* Caller should verify both ref and tag to be valid */
> > diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > index ed1bdcf1f8ab..f2f574bcf383 100644
> > --- a/lib/alloc_tag.c
> > +++ b/lib/alloc_tag.c
> > @@ -767,50 +767,82 @@ static __init bool need_page_alloc_tagging(void)
> >    * their codetag uninitialized. Track these early PFNs so we can clea=
r
> >    * their codetag refs later to avoid warnings when they are freed.
> >    *
> > - * Early allocations include:
> > - *   - Base allocations independent of CPU count
> > - *   - Per-CPU allocations (e.g., CPU hotplug callbacks during smp_ini=
t,
> > - *     such as trace ring buffers, scheduler per-cpu data)
> > - *
> > - * For simplicity, we fix the size to 8192.
> > - * If insufficient, a warning will be triggered to alert the user.
> > + * Each page is cast to a pfn_pool: the first few bytes hold metadata
> > + * (next pointer and slot count), the remainder stores PFNs.
> > + */
> > +struct pfn_pool {
> > +     struct pfn_pool *next;
> > +     atomic_t count;
> > +     unsigned long pfns[];
> > +};
> > +
> > +#define PFN_POOL_SIZE                        ((PAGE_SIZE - offsetof(st=
ruct pfn_pool, pfns)) / \
> > +                                      sizeof(unsigned long))
> > +
> > +/*
> > + * Skip early PFN recording for a page allocation.  Reuses the
> > + * %__GFP_NO_OBJ_EXT bit.  Used by __alloc_tag_add_early_pfn() to avoi=
d
> > + * recursion when allocating pages for the early PFN tracking list
> > + * itself.
> >    *
> > - * TODO: Replace fixed-size array with dynamic allocation using
> > - * a GFP flag similar to ___GFP_NO_OBJ_EXT to avoid recursion.
> > + * Codetags of the pages allocated with __GFP_NO_CODETAG should be
> > + * cleared (via clear_page_tag_ref()) before freeing the pages to prev=
ent
> > + * alloc_tag_sub_check() from triggering a warning.
> >    */
> > -#define EARLY_ALLOC_PFN_MAX          8192
> > +#define __GFP_NO_CODETAG             __GFP_NO_OBJ_EXT
> >
> > -static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX] __initdata;
> > -static atomic_t early_pfn_count __initdata =3D ATOMIC_INIT(0);
> > +static struct pfn_pool *current_pfn_pool __initdata;
> >
> >   static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
> >   {
> > -     int old_idx, new_idx;
> > +     struct pfn_pool *pool;
> > +     int idx;
> >
> >       do {
> > -             old_idx =3D atomic_read(&early_pfn_count);
> > -             if (old_idx >=3D EARLY_ALLOC_PFN_MAX) {
> > -                     pr_warn_once("Early page allocations before page_=
ext init exceeded EARLY_ALLOC_PFN_MAX (%d)\n",
> > -                                   EARLY_ALLOC_PFN_MAX);
> > -                     return;
> > +             pool =3D READ_ONCE(current_pfn_pool);
> > +             if (!pool || atomic_read(&pool->count) >=3D PFN_POOL_SIZE=
) {
> > +                     struct page *new_page =3D alloc_page(__GFP_HIGH |=
 __GFP_NO_CODETAG);
> > +                     struct pfn_pool *new;
> > +
> > +                     if (!new_page) {
> > +                             pr_warn_once("early PFN tracking page all=
ocation failed\n");
> > +                             return;
> > +                     }
> > +                     new =3D page_address(new_page);
> > +                     new->next =3D pool;
> > +                     atomic_set(&new->count, 0);
> > +                     if (cmpxchg(&current_pfn_pool, pool, new) !=3D po=
ol) {
> > +                             clear_page_tag_ref(new_page);
> > +                             __free_page(new_page);
> > +                             continue;
> > +                     }
> > +                     pool =3D new;
> >               }
> > -             new_idx =3D old_idx + 1;
> > -     } while (!atomic_try_cmpxchg(&early_pfn_count, &old_idx, new_idx)=
);
> > +             idx =3D atomic_read(&pool->count);
> > +             if (idx >=3D PFN_POOL_SIZE)
> > +                     continue;
> > +             if (atomic_cmpxchg(&pool->count, idx, idx + 1) =3D=3D idx=
)
> > +                     break;
> > +     } while (1);
> >
> > -     early_pfns[old_idx] =3D pfn;
> > +     pool->pfns[idx] =3D pfn;
> >   }
> >
> >   typedef void alloc_tag_add_func(unsigned long pfn);
> >   static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refdat=
a =3D
> >       RCU_INITIALIZER(__alloc_tag_add_early_pfn);
> >
> > -void alloc_tag_add_early_pfn(unsigned long pfn)
> > +void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
> >   {
> >       alloc_tag_add_func *alloc_tag_add;
> >
> >       if (static_key_enabled(&mem_profiling_compressed))
> >               return;
> >
> > +     /* Skip allocations for the tracking list itself to avoid recursi=
on. */
> > +     if (gfp_flags & __GFP_NO_CODETAG)
> > +             return;
> > +
> >       rcu_read_lock();
> >       alloc_tag_add =3D rcu_dereference(alloc_tag_add_early_pfn_ptr);
> >       if (alloc_tag_add)
> > @@ -820,7 +852,9 @@ void alloc_tag_add_early_pfn(unsigned long pfn)
> >
> >   static void __init clear_early_alloc_pfn_tag_refs(void)
> >   {
> > -     unsigned int i;
> > +     struct pfn_pool *pool, *next;
> > +     struct page *page;
> > +     int i;
> >
> >       if (static_key_enabled(&mem_profiling_compressed))
> >               return;
> > @@ -829,37 +863,45 @@ static void __init clear_early_alloc_pfn_tag_refs=
(void)
> >       /* Make sure we are not racing with __alloc_tag_add_early_pfn() *=
/
> >       synchronize_rcu();
> >
> > -     for (i =3D 0; i < atomic_read(&early_pfn_count); i++) {
> > -             unsigned long pfn =3D early_pfns[i];
> > -
> > -             if (pfn_valid(pfn)) {
> > -                     struct page *page =3D pfn_to_page(pfn);
> > -                     union pgtag_ref_handle handle;
> > -                     union codetag_ref ref;
> > -
> > -                     if (get_page_tag_ref(page, &ref, &handle)) {
> > -                             /*
> > -                              * An early-allocated page could be freed=
 and reallocated
> > -                              * after its page_ext is initialized but =
before we clear it.
> > -                              * In that case, it already has a valid t=
ag set.
> > -                              * We should not overwrite that valid tag=
 with CODETAG_EMPTY.
> > -                              *
> > -                              * Note: there is still a small race wind=
ow between checking
> > -                              * ref.ct and calling set_codetag_empty()=
. We accept this
> > -                              * race as it's unlikely and the extra co=
mplexity of atomic
> > -                              * cmpxchg is not worth it for this debug=
-only code path.
> > -                              */
> > -                             if (ref.ct) {
> > +     for (pool =3D current_pfn_pool; pool; pool =3D next) {
> > +             int nr_pfns =3D atomic_read(&pool->count);
> > +
> > +             for (i =3D 0; i < nr_pfns; i++) {
> > +                     unsigned long pfn =3D pool->pfns[i];
> > +
> > +                     if (pfn_valid(pfn)) {
> > +                             union pgtag_ref_handle handle;
> > +                             union codetag_ref ref;
> > +
> > +                             if (get_page_tag_ref(pfn_to_page(pfn), &r=
ef, &handle)) {
> > +                                     /*
> > +                                      * An early-allocated page could =
be freed and reallocated
> > +                                      * after its page_ext is initiali=
zed but before we clear it.
> > +                                      * In that case, it already has a=
 valid tag set.
> > +                                      * We should not overwrite that v=
alid tag
> > +                                      * with CODETAG_EMPTY.
> > +                                      *
> > +                                      * Note: there is still a small r=
ace window between checking
> > +                                      * ref.ct and calling set_codetag=
_empty(). We accept this
> > +                                      * race as it's unlikely and the =
extra complexity of atomic
> > +                                      * cmpxchg is not worth it for th=
is debug-only code path.
> > +                                      */
> > +                                     if (ref.ct) {
> > +                                             put_page_tag_ref(handle);
> > +                                             continue;
> > +                                     }
> > +
> > +                                     set_codetag_empty(&ref);
> > +                                     update_page_tag_ref(handle, &ref)=
;
> >                                       put_page_tag_ref(handle);
> > -                                     continue;
> >                               }
> > -
> > -                             set_codetag_empty(&ref);
> > -                             update_page_tag_ref(handle, &ref);
> > -                             put_page_tag_ref(handle);
> >                       }
> >               }
> >
> > +             next =3D pool->next;
> > +             page =3D virt_to_page(pool);
> > +             clear_page_tag_ref(page);
> > +             __free_page(page);
> >       }
> >   }
> >   #else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index d49c254174da..50b2bc8f42d9 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1240,7 +1240,7 @@ void __clear_page_tag_ref(struct page *page)
> >   /* Should be called only if mem_alloc_profiling_enabled() */
> >   static noinline
> >   void __pgalloc_tag_add(struct page *page, struct task_struct *task,
> > -                    unsigned int nr)
> > +                    unsigned int nr, gfp_t gfp_flags)
> >   {
> >       union pgtag_ref_handle handle;
> >       union codetag_ref ref;
> > @@ -1254,17 +1254,17 @@ void __pgalloc_tag_add(struct page *page, struc=
t task_struct *task,
> >                * page_ext is not available yet, record the pfn so we ca=
n
> >                * clear the tag ref later when page_ext is initialized.
> >                */
> > -             alloc_tag_add_early_pfn(page_to_pfn(page));
> > +             alloc_tag_add_early_pfn(page_to_pfn(page), gfp_flags);
> >               if (task->alloc_tag)
> >                       alloc_tag_set_inaccurate(task->alloc_tag);
> >       }
> >   }
> >
> >   static inline void pgalloc_tag_add(struct page *page, struct task_str=
uct *task,
> > -                                unsigned int nr)
> > +                                unsigned int nr, gfp_t gfp_flags)
> >   {
> >       if (mem_alloc_profiling_enabled())
> > -             __pgalloc_tag_add(page, task, nr);
> > +             __pgalloc_tag_add(page, task, nr, gfp_flags);
> >   }
> >
> >   /* Should be called only if mem_alloc_profiling_enabled() */
> > @@ -1297,7 +1297,7 @@ static inline void pgalloc_tag_sub_pages(struct a=
lloc_tag *tag, unsigned int nr)
> >   #else /* CONFIG_MEM_ALLOC_PROFILING */
> >
> >   static inline void pgalloc_tag_add(struct page *page, struct task_str=
uct *task,
> > -                                unsigned int nr) {}
> > +                                unsigned int nr, gfp_t gfp_flags) {}
> >   static inline void pgalloc_tag_sub(struct page *page, unsigned int nr=
) {}
> >   static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsig=
ned int nr) {}
> >
> > @@ -1852,7 +1852,7 @@ inline void post_alloc_hook(struct page *page, un=
signed int order,
> >
> >       set_page_owner(page, order, gfp_flags);
> >       page_table_check_alloc(page, order);
> > -     pgalloc_tag_add(page, current, 1 << order);
> > +     pgalloc_tag_add(page, current, 1 << order, gfp_flags);
> >   }
> >
> >   static void prep_new_page(struct page *page, unsigned int order, gfp_=
t gfp_flags,

