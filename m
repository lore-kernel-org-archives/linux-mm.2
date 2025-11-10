Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F11DCCFA1A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 07:21:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEE988E001A; Mon, 10 Nov 2025 02:21:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC5D38E0002; Mon, 10 Nov 2025 02:21:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DBE38E001A; Mon, 10 Nov 2025 02:21:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88BAD8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 02:21:50 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 439D212DA95
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 07:21:50 +0000 (UTC)
X-FDA: 84093852780.27.0099A6C
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id 67A06100003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 07:21:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j4fYBP1V;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762759308; a=rsa-sha256;
	cv=none;
	b=YW1wxlLxbLPFAC828MyCqeZx0LMc2h4GcXmdbzvEQPwzWnFQNo2GAN54N7oxPJDkv64RgP
	OTBYShkUf4kd2EHSzz209lyvjq8kXG25tA/XaWspGn8oSzJ3HtwuBJ6z0MrCiLKS6gC1P4
	3JGODug1j2YaJ8tJAfem76wZuVDl7W4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j4fYBP1V;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762759308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GoBnDddgwxi54Ox4ulLdEbbKlN5YhwIYGFKDFNhc/GM=;
	b=2aRPMghYUoh/ZjaeKrHYV3q0bcQYVE8yj7ewmQ0TYf7Brlk9gTJ26G0jkwZQzPyj6GaHGK
	DjuTXqV+kGW55wapsbwjXIxNQmgAK2ngZGQsiUlEL5xSHSrPpdbmXy6l0rTpkYfkaFME2Y
	rzL2HOk5ONmb7ilX03FZGNv/1veATkE=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-880439c5704so22550816d6.1
        for <linux-mm@kvack.org>; Sun, 09 Nov 2025 23:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762759307; x=1763364107; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GoBnDddgwxi54Ox4ulLdEbbKlN5YhwIYGFKDFNhc/GM=;
        b=j4fYBP1VBBl6qHD4xp9txBZ+mruwmHdLPTbRYrA1kFLBwmLWw7q1s1Wao2BFjOuIJA
         mTXWaBunJ6rtsnpbyDoyifx8/3KOILIvR7Ps8szW07xy6c4NkY6ytHqXnoUdylnRMijp
         RD5uegChscM54NKzZE57Eh3cH5vK0/s5L/7i64eLrndfmBbr38Z3BZfWAVOWOaFELhtk
         03/P/zScR+Q2GKapgmhkN4PVUjhATjmG8A0IzD83mz5mWklPFCzApxNKj0vGRYrAUDQ1
         Vg09lrVRj61hotVL+teifWrJkDsKLsksBbYAbUTrMaToKIFvVtJ+5BbLIHPJVBLoxd0V
         Xc+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762759307; x=1763364107;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GoBnDddgwxi54Ox4ulLdEbbKlN5YhwIYGFKDFNhc/GM=;
        b=V2AGpkBEQxfH7dMNoLe8/bUvpAbwJN0X7I7X0FACRJk0dH9fOLTbWLp5g/Oh8zGYgP
         YLYoAC33+bH93rFliQOzzAzWVbotECHU5+aDqRR7GRNfplJcPV1GSzIOa8yoCbSF4Qho
         uwKa7nnV/Ydydcm9VEbcBn0vu3OVT7WVFAfSFiATLX7qGqQduipsAK4Dn4XcQu4l+kYS
         vj4Yxuk5+4lK2f8UX9w4wAF3DXaMyr/ECIbXLicyhvG4kD1thq3ACvxw3WSbBMABPX1D
         RM4V7+teFR4h25NhE5w0g9OSxkqyrRkgRsKVfRr7qGcQk2iWLQJP1MNznT7ZdWSHAoOf
         BJLA==
X-Gm-Message-State: AOJu0YyjY7TdXU6naLRTEsIZ+z7aswiVx9cEVjFFWP5kdBLFvr8/b1Ho
	IGU5WMG372wDlMRCtXRmmuJ9d517xGVegzuFDsxl30vVIpI1yWk/1+NityS0teOLw+c/myvm2qf
	gvNzjpoFcLPFW0egzi4dbEw51ByeOa10=
X-Gm-Gg: ASbGncsEm+o1zkWXMGllsU3tXapWjTMFv9+v+vOrU6UUf+Qy3tbP9PSWqMMDGz36QKa
	yRRR04cadS+WJCSZDLV16lN3Z5ZHPtYSYQ1Qb720xianHVklojJebyyS8qOYCUk7EYUmVyA8PY9
	EtTAhF9VhImyTOqrPVjem3pLZ04yWmKZnWieRoFuaYUIeeNSI5AnzH4dnPdOqiCOO9y+mE5s01w
	Cp8aSHdmkOhc+ArUaFgZBibYVkbQGt5xNF7Ef2prURubv8u5OwymsJUAK9nlEIx0oo4rEIjakUv
	E61uzPI56kJWfR1MsVmZDiCFskexJdqXjSovSw==
X-Google-Smtp-Source: AGHT+IEBdVrR3hNO6pDaxwfyknGdyA8SyCItARstRpB9gJQWXGbeUcoj8HHGmoH2ybsWzG2TRwFckQUVQYzfGCKj9wQ=
X-Received: by 2002:ad4:5947:0:b0:87c:28cc:9e69 with SMTP id
 6a1803df08f44-882386ed75emr110475186d6.55.1762759307133; Sun, 09 Nov 2025
 23:21:47 -0800 (PST)
MIME-Version: 1.0
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
 <20251029-swap-table-p2-v1-13-3d43f3b6ec32@tencent.com> <CAGsJ_4xquj2Kbc2qu0vtY6Q+-q3sg56BgKEdPs8eHtKxLBk0gQ@mail.gmail.com>
 <CAMgjq7CDXh5OWy5BMXzNPCSuMQfODTdFPOhpCDGXrhisNfAGdg@mail.gmail.com>
In-Reply-To: <CAMgjq7CDXh5OWy5BMXzNPCSuMQfODTdFPOhpCDGXrhisNfAGdg@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 10 Nov 2025 15:21:35 +0800
X-Gm-Features: AWmQ_bkaePCXz9PxjeKLBi1CR7nTqqrSmYzt2ZcuiFZI3AOKt-kIolk1ydLq4N8
Message-ID: <CAGsJ_4yjU0NmQe0cM2xDkMYVdAWRc2Q1FUMGxpo8cVkEt5ifVQ@mail.gmail.com>
Subject: Re: [PATCH 13/19] mm, swap: remove workaround for unsynchronized swap
 map cache state
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	David Hildenbrand <david@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 67A06100003
X-Stat-Signature: w5nwwgwkiuzey5igi3mcrac7ehym48y5
X-HE-Tag: 1762759308-474286
X-HE-Meta: U2FsdGVkX18EhfXngiYnytgoH+G+yYf2rPRAsvN1KOBDmRKlV3wmCfeqBFzgcMLwuMfiIN/1N7CoSRtxkh+gOl/n069nF4+zXjtYcHvfwWrv8ZONfhYRxQ8OEE3ZUZrov9liWp6mQbFyUSEfzxqcB16nhjhPa5+efMdvlX/tnpaZm53AiVhXSt41vuTqr8YeOU1eb7swP5pqg916c72Hg5IuLbokZN7DtJKtwCeIdNevCh/cZE0se6XsKyAkcmQVVaCDXcr9lG2kdv6SyUAk+1bDPl9HECie83McrcSPPMhOxj3jL3AOfp2Ftwcxc75VL6hCyH3BsUrKucjptU2e/MdP8Cqjw4R1ZCU/BI1RFi4nyj/+tNgKe+FBFGuVxxGfApotVWwDz4qD6csZAmEqOZdpUMG7De/h85AX1HYL0ujOGgtyMclvx1TRqzvlicUKf9SYqNAyzGLt7suByTu3fiR6IhpVGAmtSKGS3soHVRXZDFusWs2G1TObhjMuSZqpLOjo0Cb53ZPrf6WxfxL1jvoyEDFHOyJkQ2nSGirk/mqdO1A+Np2WbNHEcjfc4J2e1WZSAFKFh42CachYu7qsius10dyAMP4vwH8rgnidnpJvXc5fn85+p0V9V+mk8uDICc2HIMG+SzyW0evIHSroJxhqSJsKBdULd/iXcPbAVd5HUbppmQBQQj8Nyp5q+sIoEpAaI3QCMkx5y4DvkfylzyuUa17YGP1BV9tyl1G4GLaUIVUpnIDnLWPPnz/q0fxeh/HZ7MtAM1F2Wx+1k46pPSyJDVaYgpdvTqmU5pToPYvVeb/5IH02ivOoyB3E7GFBkAi9OP/tSxcXnpWY61wh0TCVMmLtsDGOag9cvw1f8EXj3nUrWTm3BXChxmoFdA0PMuMlpU5EIw7K7twNwTpfBA+ABaDoayxEf65Kx9oFvL89Bp7ikKEX8/pM6AGPfAIQHddCaRMoY3SPOArwRc+
 MUtAFxm7
 UzR8hVfvpqkJo5xlJ2PuLp/AKEOGjimO6uuCHFZROsHXz7wLvK0ZIahEODWldUj23PhHaPRpnN1pIj2FZ0+nnZzdodJjNofxGbChgXD+TC8eJKW6OjqhbJZIkfZqUoE/sH12fg4cayuQMcySgCWpFFdGYmq2pHBH8Xjp1URMPm85LqnVP4YdbDtvopKiReGCbHgckUyRgpTdC2vGf3UHFV+XDWaGTJb1MqIUadBYK7jTN2sONgffIhhzXiOd0AKdBF8TE8dJOp5nRL0D64Yr5YV7RpOMprorm6f8U8jBeQsiTkPA6gw+v45SqyNCDtWr6GejMX8Vg9cYGHDNBecyQiLEybmHCB3wv6gxn/kRdjhj30hetxmcPa10zJ1JA9jCrtuH+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 9, 2025 at 10:18=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Fri, Nov 7, 2025 at 11:07=E2=80=AFAM Barry Song <21cnbao@gmail.com> wr=
ote:
> >
> > >  struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_ma=
sk,
> > >                                      struct mempolicy *mpol, pgoff_t =
ilx,
> > > -                                    bool *new_page_allocated,
> > > -                                    bool skip_if_exists)
> > > +                                    bool *new_page_allocated)
> > >  {
> > >         struct swap_info_struct *si =3D __swap_entry_to_info(entry);
> > >         struct folio *folio;
> > > @@ -548,8 +542,7 @@ struct folio *swap_cache_alloc_folio(swp_entry_t =
entry, gfp_t gfp_mask,
> > >         if (!folio)
> > >                 return NULL;
> > >         /* Try add the new folio, returns existing folio or NULL on f=
ailure. */
> > > -       result =3D __swap_cache_prepare_and_add(entry, folio, gfp_mas=
k,
> > > -                                             false, skip_if_exists);
> > > +       result =3D __swap_cache_prepare_and_add(entry, folio, gfp_mas=
k, false);
> > >         if (result =3D=3D folio)
> > >                 *new_page_allocated =3D true;
> > >         else
> > > @@ -578,7 +571,7 @@ struct folio *swapin_folio(swp_entry_t entry, str=
uct folio *folio)
> > >         unsigned long nr_pages =3D folio_nr_pages(folio);
> > >
> > >         entry =3D swp_entry(swp_type(entry), round_down(offset, nr_pa=
ges));
> > > -       swapcache =3D __swap_cache_prepare_and_add(entry, folio, 0, t=
rue, false);
> > > +       swapcache =3D __swap_cache_prepare_and_add(entry, folio, 0, t=
rue);
> > >         if (swapcache =3D=3D folio)
> > >                 swap_read_folio(folio, NULL);
> > >         return swapcache;
> >
> > I wonder if we could also drop the "charged" =E2=80=94 it doesn=E2=80=
=99t seem
> > difficult to move the charging step before
> > __swap_cache_prepare_and_add(), even for swap_cache_alloc_folio()?
>
> Hi Barry, thanks for the review and suggestion.
>
> It may cause much more serious cgroup thrashing. Charge may cause
> reclaim, so races swapin will have a much larger race window and cause
> a lot of repeated folio alloc / charge.
>
> This param exists because anon / shmem does their own charge for large
> folio swapin, and then inserts the folio into the swap cache, which is
> causing more memory pressure already. I think ideally we want to unify
> all alloc & charging for swap in folio allocation, and have a
> swap_cache_alloc_folio that supports `orders`. For raced swapin only
> one will insert a folio successfully into the swap cache and charge
> it, which should make the race window very tiny or maybe avoid
> redundant folio allocation completely with further work. I did some
> tests and it shows that it will improve the memory usage and avoid
> some OOM under pressure for (m)THP.

This is quite interesting. I wonder if the change below could help reduce
mTHP swap thrashing. The fallback order-0 path also changes after
swap_cache_add_folio(), as order-0 pages are typically the ones triggering
memcg reclamation.

diff --git a/mm/memory.c b/mm/memory.c
index 27d91ae3648a..d97f1a8a5ca3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4470,11 +4470,13 @@ static struct folio *__alloc_swap_folio(struct
vm_fault *vmf)
                return NULL;

        entry =3D pte_to_swp_entry(vmf->orig_pte);
+#if 0
        if (mem_cgroup_swapin_charge_folio(folio, vma->vm_mm,
                                           GFP_KERNEL, entry)) {
                folio_put(folio);
                return NULL;
        }
+#endif

        return folio;
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 2bf72d58f6ee..9d0b55deacc6 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -605,7 +605,7 @@ struct folio *swapin_folio(swp_entry_t entry,
struct folio *folio)
        unsigned long nr_pages =3D folio_nr_pages(folio);

        entry =3D swp_entry(swp_type(entry), round_down(offset, nr_pages));
-       swapcache =3D __swap_cache_prepare_and_add(entry, folio, 0, true);
+       swapcache =3D __swap_cache_prepare_and_add(entry, folio, 0,
folio_order(folio));
        if (swapcache =3D=3D folio)
                swap_read_folio(folio, NULL);
        return swapcache;

>
> BTW with current SWAP_HAS_CACHE design, we also have redundant folio
> alloc for order 0 when under global pressure, as folio alloc is done
> before setting SWAP_HAS_CACHE.  But having SWAP_HAS_CACHE set then do
> the folio alloc will increase the chance of hitting the idle/busy loop
> on SWAP_HAS_CACHE which is also kind of problematic. We should be able
> to clean it up in later phases.

Thanks
Barry

