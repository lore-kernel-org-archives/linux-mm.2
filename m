Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2406CCDE000
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 23:08:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEC3F6B0088; Wed, 24 Jun 2026 19:08:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC3466B008A; Wed, 24 Jun 2026 19:08:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C00D76B008C; Wed, 24 Jun 2026 19:08:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B1636B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:08:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0D2FA8D29D
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 23:08:17 +0000 (UTC)
X-FDA: 84916346634.27.83D2AE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3049D20004
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 23:08:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eVA0dFMK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782342495;
	b=76HKf9+OH3V40gFXLrc5OlqgZxm/h2kpnKcWD5UiyJxzK/xU1hIGUkVzWcRZhp/8AndkLJ
	gAwnFy/De6yZXFkbd74t0P6fNDjK6c5C/SVRHW1uGB5AEQsr5mrteh08a/yRGxdgkKQGOv
	piUPtHQ+LkPK70RpH+29PWw6eLV62dM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782342495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yI1W7nlZgfOH8ZGOsQ6LYkWHTo6p0grxRReXdLmoAaI=;
	b=7p37LIRxtBajvmA0VqN2tGQo6eVjr8Okqd2wsjRmPvyuE/QTwb3/dYlH22muImjOk1eshP
	7ZsD/LcUIXNe1j9O5eOAd4N/raMJkzyU/FXHxJ9SSq+ngxm9hHQvSEORsFSFlwAfKHUMj4
	3iayvqWHEZwTcDXrMEtqbdd1mtHJ4Vk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eVA0dFMK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 79AD8600C3
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 23:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EACF1F00ADB
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 23:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782342494;
	bh=yI1W7nlZgfOH8ZGOsQ6LYkWHTo6p0grxRReXdLmoAaI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=eVA0dFMKnh+GrpwbDbMhInoVpF5a9cV2E2naqcKKwrAQhmZ6JROzqxmFNScPrMQuO
	 /zaQ8ALtahmYi82HLdRSdVww9GrgZQ7Ab8vonMmbJz0ywe48Dvx0oCRGG3pKwQsL2g
	 +IJ4cEo7crReNZLktLd3KmFFuAoolcWP4JNrYW9oYYphG0BWuklspN5robAjTyUtkN
	 h7e1ZxrXqVm5P81AzDIBBgLutg2Hzcy+HfFSZYfc66zFspFUNFBIZL6Ee+tIvfzysH
	 z3nRFMTXZAbN85O4gej7Ea2mEldiJ8irFQhPtdt+er3Lbl5c+Mmo/p80DAz+H4jCFV
	 CwKUKQoNrywJw==
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8de7bfa323bso13177776d6.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:08:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqYrzNFg9CxEGf1AQ1QCm1GmaGLTBxKizApxvHqCL0upfoDoBox+Ti7Mq/qHtXxx8nY0hxrHuiUGw==@kvack.org
X-Gm-Message-State: AOJu0YxvudYpr5fs1yXje2RdzynVN0I3aZGBOYN2pzB6Vq8sdIlptE0q
	m1KfA6PhRw0IZ//T/uY8QcbSg6beWp0lzQbIAk210Ch8JR92vzljTldUTe/1pfwYJMkyJQezWJo
	XlkX2lSl8/cHQsmzBuRb1FtMr/9XHzEI=
X-Received: by 2002:a05:6214:1c89:b0:8b3:f911:c1df with SMTP id
 6a1803df08f44-8e6d7f0ba8bmr3515376d6.21.1782342493535; Wed, 24 Jun 2026
 16:08:13 -0700 (PDT)
MIME-Version: 1.0
References: <5790c4a4-d502-4180-82f5-47de5809a4fe@kernel.org>
 <20260620081017.89085-1-baohua@kernel.org> <4aa8350e-712f-4380-b3bf-2ff06cf2a35d@kernel.org>
In-Reply-To: <4aa8350e-712f-4380-b3bf-2ff06cf2a35d@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Thu, 25 Jun 2026 07:08:01 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xR0Ge707s8JAfd5Fw10+U+25_nuBGuVayx9qnxR+NnGQ@mail.gmail.com>
X-Gm-Features: AVVi8Cdsw01jxn8mqFfZisv7_4PtFUBjBj14zeB_GtU7N2Wqd2ZbBieEtugDvAQ
Message-ID: <CAGsJ_4xR0Ge707s8JAfd5Fw10+U+25_nuBGuVayx9qnxR+NnGQ@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: Avoiding split large folios if swap has no space
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, dev.jain@arm.com, kasong@tencent.com, 
	lance.yang@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, npache@redhat.com, qi.zheng@linux.dev, 
	ryan.roberts@arm.com, shakeel.butt@linux.dev, weixugc@google.com, 
	yuanchu@google.com, zhaonanzhe@xiaomi.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3049D20004
X-Rspam-User: 
X-Stat-Signature: tssbo11n31jgdxehhkwohp3cfuk4d7sb
X-HE-Tag: 1782342495-948432
X-HE-Meta: U2FsdGVkX194fMcgpqj9mGUVGGvAzJ683G5g3VvENUglaOb/1YfpDz7eH7Rwz3fd8DmRnBgLxcciW8zKzeE7tlGh7I6jkspI/Hz4HPFJd4MaEw72phVFn1dYVj9N7H0jsZHWHJdJjCULEw6BMpN1ja4EjZ37fceYHEYkFFGYPtk4R158KM/p/J48FCgxTmZUKhvDfAVPji3fJIXUuqpno3fWRMn67aosEZ+/kRFch49COdDDdc1a3j+KB94v7h/rGGRVPpu4OMx75QQkxAInEBXPO82qr2qf40XNtNfNj3qrYGUMX3ivvOHw6Wbtb6TIeBmsxoWHKoeNJpl9b/E1vn2qXkX5yEhTP7yTQfPemSd0C9yGF6IRkiqywXb/l31ybTqJdqc/GN360B29aLVEVEhleq3ApoN4ncqNIp8QCcayoWAmJTP/MS2Y9JMlqS4lRz9tYPAYtltiAnc2ot75oHhEn+LCoxbQoBTnC1v+Gj+FcWDEHLyO8FMDWTqggCo4OIlQ6RLfTS6vRHzpqHS2IKXmK+3m3S4X+8BLjJoZoI5hDxYgmMR6JEhZ7c2+cfUNP2x5pfmhc8Zf5XLlieu2lDlc/yOSTln+38Zr5qMOhy5SEdD6HM2yJ4E93GHt1gu3DJA8fCzxEdGgSI0S716DcPasPpy7lUhiHBSuPAB5jvnqgmux+YE9iBY0NIEXRQyMxzRSkDr6Tf92iT4yJl3xP7BT1Guf9SRZ2bujbM3DPogwNARsnoQxiWDcQ0UCq3yoZtkr3prd1oYbufwivyFXnSZpg217R2v2KSNE6ix34srYfDVfn5JFK5xmxdoHt04nu06rK7WgDs8T8MDVJOqyvNcuAiCBGBAx8HCMGZuK/oWIQPmfQocHxAxh51OTXqXN8Kl2bHoWUkjiDQZdazFuqFENWXc6iJc0k9XGttw0D4cz7PrNMHj49hb0AzVw+Yaz38VfLbtLzGk5ln5DK4i
 XjaK2D2Y
 3PlG05SURudVuX74fD5mAQLpvTFsvEsoezpXFwT9U0wy/jvzFB/QA4fn9wUOR6wTBfjIm7U2JHrCjX8LRLDPBO/kAgtybARaoq+Y5giW16+okdTfDXjGl1o1qNXybJwbnOSH6EHJgR1fykGDZUwidCBnlqSoj+ujnkJXUWrO9PIMaNt2K+b07TIXalCVJ3OCM3xSt7sklixhCI5trHn+Lx3pIBGC0N2byIGLM2beE6u9qLIgjydN82R+D4Dg0ySO6IhUk6qepwC+WZyj1/FbpaIG3PezUknfNn4/aRoPvjSunQrOrxy0q8+hqtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 4:58=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 6/20/26 10:10, Barry Song (Xiaomi) wrote:
> > On Fri, Jun 19, 2026 at 10:04=E2=80=AFPM David Hildenbrand (Arm) <david=
@kernel.org> wrote:
> > [...]
> >>>       /*
> >>>        * The page can not be swapped.
> >>>        *
> >>> @@ -1280,6 +1289,8 @@ static unsigned int shrink_folio_list(struct li=
st_head *folio_list,
> >>>
> >>>                               if (!folio_test_large(folio))
> >>>                                       goto activate_locked_split;
> >>> +                             if (!__can_reclaim_anon_pages(memcg, sc=
))
> >>> +                                     goto activate_locked_split;
> >>
> >> Why are we even trying to allocate swap space if we cannot reclaim suc=
h pages?
> >> Makes we wonder whether we would want to have that check earlier, befo=
re the
> >> folio_alloc_swap().
> >>
> >> Any downsides?
> >
> > I don't think there are any obvious downsides there. One issue is that
> > the memcg may not be passed from reclaim_pages(), so memcg would
> > always be NULL. However, the folio could still belong to a memcg
> > whose swap quota has been exhausted. In that case, my
> > __can_reclaim_anon_pages() will fail when checking whether we can
> > swap out. But switching to folio_memcg() also seems awkward.
> >
> > So I feel Kairui=E2=80=99s suggestion [1] might be the best approach. I=
n
> > folio_alloc_swap(), we return -EAGAIN to tell vmscan.c that
> > we can split the folio and retry the swap-out.
> > only when there are sufficient swap slots and sufficient memcg swap
> > quota do we return -EAGAIN, allowing vmscan to perform a split.
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 78b49b0658ad..62e2c506ccae 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -1755,6 +1755,9 @@ int folio_alloc_swap(struct folio *folio)
> >                       VM_WARN_ON_ONCE(1);
> >                       return -EINVAL;
> >               }
> > +
> > +             if (get_nr_swap_pages() < (1 << order))
> > +                     return -ENOMEM;
>
> I guess we could be clearer with the return value:
>
> -> !get_nr_swap_pages() -> -ENOSPC / -ENOMEM
>
> (no space at all)
>
> -> get_nr_swap_pages() < (1 << order) -> -E2BIG
>
> (there is some space, but not for the full thing)

understood. make sense.

>
> But now I wonder whether we would also want to check "is there any free s=
wap
> space", not just "is there any swap".

I don't quite understand you. get_nr_swap_pages() returns
nr_swap_pages, which increases or decreases as swap is allocated or
freed. I guess it just reflects how many swaps we currently have
available?

>
>
> Essentially, try returning -E2BIG if there is the chance to swap out afte=
r
> split, and  -ENOSPC / -ENOMEM if a split wouldn't help.
>
> >       }
> >
> >  again:
> > @@ -1769,11 +1772,13 @@ int folio_alloc_swap(struct folio *folio)
> >       }
> >
> >       /* Need to call this even if allocation failed, for MEMCG_SWAP_FA=
IL. */
> > -     if (unlikely(mem_cgroup_try_charge_swap(folio)))
> > +     if (unlikely(mem_cgroup_try_charge_swap(folio))) {
> >               swap_cache_del_folio(folio);
> > +             return -ENOMEM;
>
> Here we wouldn't have the information whether we could charge after a spl=
it.
>
> So that would require a rework to signal this more cleanly to the caller.

Yep. The tricky part is that mem_cgroup_try_charge_swap() cannot
return how much swap quota is available in the memcg. Do you prefer to
add an output argument to mem_cgroup_try_charge_swap() to expose
that, or should we introduce a separate wrapper such as =E2=80=A6

long get_nr_swap_pages_from_folio_memcg(struct folio *folio)
{
         long int nr;
         memcg =3D get_memcg_from_folio(folio);
         nr =3D mem_cgroup_get_nr_swap_pages(memcg);

         return nr;
}

then in folio_alloc_swap(), if nr < folio_nr_pages() but > 0,
we ask for a split by returning -E2BIG ?

>
> > +     }
> >
> >       if (unlikely(!folio_test_swapcache(folio)))
> > -             return -ENOMEM;
> > +             return -EAGAIN;
> >
> >       return 0;
> >  }
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 299b5d9e8836..63e8578454ea 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -1257,6 +1257,8 @@ static unsigned int shrink_folio_list(struct list=
_head *folio_list,
> >                */
> >               if (folio_test_anon(folio) && folio_test_swapbacked(folio=
) &&
> >                               !folio_test_swapcache(folio)) {
> > +                     int ret;
> > +
> >                       if (!(sc->gfp_mask & __GFP_IO))
> >                               goto keep_locked;
> >                       if (folio_maybe_dma_pinned(folio))
> > @@ -1275,10 +1277,10 @@ static unsigned int shrink_folio_list(struct li=
st_head *folio_list,
> >                                   split_folio_to_list(folio, folio_list=
))
> >                                       goto activate_locked;
> >                       }
> > -                     if (folio_alloc_swap(folio)) {
> > +                     if ((ret =3D folio_alloc_swap(folio))) {
>
> I prefer doing the assignment outside the conditional.

Ok.

>
> >                               int __maybe_unused order =3D folio_order(=
folio);
> >
> > -                             if (!folio_test_large(folio))
> > +                             if (!folio_test_large(folio) || ret !=3D =
-EAGAIN)
> >                                       goto activate_locked_split;
> >                               /* Fallback to swap normal pages */
> >                               if (split_folio_to_list(folio, folio_list=
))
> >
> > What=E2=80=99s your view on this, David?
>
> I guess returning from folio_alloc_swap() whether a split could allow for
> swapout (e.g., -E2BIG) would be reasonable.
>
> To catch all the cases where it makes a difference:
> * No free swap space (split won't work)
> * Some free swap space (split would work)
> * Sufficient free swap space, but fragmented (split would work)
> * No memcg space (split won't work)
> * Some memcg space (split would work)

Right. The memcg part is the tricky one, since we don=E2=80=99t have that
information available.

Best Regards
Barry

