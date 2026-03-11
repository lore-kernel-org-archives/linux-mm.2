Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C008FD88F5
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 04:14:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E0776B0005; Wed, 11 Mar 2026 00:14:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68E7A6B0089; Wed, 11 Mar 2026 00:14:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56F7A6B008A; Wed, 11 Mar 2026 00:14:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2AF366B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 00:14:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AED211B84A0
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:14:49 +0000 (UTC)
X-FDA: 84532466298.02.2782DA2
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id B0F72180002
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:14:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NIFVvK6c;
	spf=pass (imf16.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773202487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1g5jdArW7KW9y5pBH1n4YAUphDc+Fz6HVl2Kp/NF71Q=;
	b=hT9OUILeqbuI08rBYlRw+PIQE4o6bfTv2ul2adHi9FsWIEp6b0IsPRE0OS0EVdZGF/02MW
	2CAQAHV1eBwc4i7EhitJ3FVlCZ+3wf1SUfilMPhvnTHpmmTml2437O9/5tkoOZofNeXs7O
	QJRpMU59GbpI6Vf7FdI8QzdJ45rdCmk=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NIFVvK6c;
	spf=pass (imf16.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773202487; a=rsa-sha256;
	cv=pass;
	b=C8bCsDHBVPii9U33y6P8dZT+VKvmMqJa1MUaf1nGVEJOl905jjyZvQu4JNwgCMtCYetgmb
	FK/0NzfsYR5JCRzwaqsiHbZQ+lzdP3JlPPtiVqZCZE/2So0KZ/pTIDZx7TuV7v3tgDFrNg
	cs7kgg7w2LRrbi8XYRp6yFQF8FkgGGA=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-50902b1006cso33855251cf.3
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 21:14:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773202487; cv=none;
        d=google.com; s=arc-20240605;
        b=YorrRIdwcvIneojhfLs/i94C5C9kJ2GweQUmHjhdF1UeO88HzeLUQD8DjsIID8pxbu
         vWmsCGKFmUDYflba0Er1FbRfOg8Bmf2WiSDJ4Cq2TpV5E1uY2lowMY83f2YYNSl7ztp+
         D9W1SfWiULwWL+ROCPpP42Pvn92BsCwK5M0BKcpSHqV1nj3MFjyn0Rf9LS2V0C09Rnrs
         Scwu+tWhd95UZG02O+LKGbPTs0smuNpJHCNu6hq/6gozX2w291+6xZt2dl/Txv2ZOZKp
         dgNbacjRcMJc4BHKgF4Dk26xF7ZPDSwKQBJ6cbdn4QSasu7niW93RWY6H+7Gy8XArMUO
         tNPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1g5jdArW7KW9y5pBH1n4YAUphDc+Fz6HVl2Kp/NF71Q=;
        fh=QwZBMUqR26V+gDg+0eKSw5On7a3idq8iwr9U38mfEu8=;
        b=YxzESWv5GYAZpxWgn48AXev8ZTUmVCGe+Uy+TXVsGrme8Ryj2hbMUf+PhavDap08aG
         5NEIZ6JXSlCtX/JRhAB9fXdL6DjcOPyB9qXz41bGHj4BfE0m9o4xeKJlhUYI7R04Zr1T
         uFD2GoFvAZbRRH6TVZUmrWSSruIq5J6FfvedppRbvhjqwXoiFGPXOJemT41G5NYjUtlH
         XTFbuDEzzifIwROUMwCqRg0K3Wn8hhcTdrhlwY4+p8kWswQkswPyZzae6zUaEAHf460h
         EDgsedQogboK1zU4WUFVnYuRc3owOCVY6ulXT0Y4ronpPgi7ri/5+2tJMVWTkBS2RFHo
         JoBQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773202487; x=1773807287; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1g5jdArW7KW9y5pBH1n4YAUphDc+Fz6HVl2Kp/NF71Q=;
        b=NIFVvK6cY554NOVtFalXw6zw9Y0eJrlLF0h5eB8Kyu24H4rWFsegjue69zoxYg4GHA
         GFGtMA9dC36wRBuap8KI30c/+smjaWEaZ7AVSdYJs/ieNM8b+HB32db03eBNVNPKpeHZ
         AX7wziYiepcVqj4ruv3UMsGpmtzsxUeV4SFBsVZEnsCrgABnkcj9YT/WUtP/b3BcmLlG
         4GKH9ijnvuF0YraZMlBibGfwROcLwUDejghg+QBaO4Ut9Pd9w69KYsQ8Ucp+F44CWSub
         pnUPNSSTkdmgScsYf7iagfZyI1hP4N7pCnpZjsMW1YMudzUFSCu/CDE9tGh1D0XQ0Fjl
         t51A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773202487; x=1773807287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1g5jdArW7KW9y5pBH1n4YAUphDc+Fz6HVl2Kp/NF71Q=;
        b=o+1y3UfRj7EtUNDaYpR3pjrUEDgHBU1/NfNBV+0NWak3TEd87peKv9v+aPzyC5ls9Y
         LOHXQdvFm0yWxxoLMWqGNnk+HaAYjNX8J5SVmRUHLRQUOmeuOuscuyYIqCa6exo9FX0S
         6kE6BnoCzultPSMnPF31VeBROtcKJyoJfj/d4wt1WT+BYhjRy042c6hyqx6C1340YrUM
         U4hooZ2sN66viIHyiEe9Dh/Z+TUtUxF7CwWN+lNp2LjfyA4R+VIww9wm7Rq0OFDTjK2r
         iNGQWysvg31PD0NNa5n36AlRI7qcwePvBY/cTsGSvrXgwRnN+A3QJGSdq2ISP8pVBGwa
         lZUA==
X-Forwarded-Encrypted: i=1; AJvYcCXD+AttAEwAA7idL/HtKtmO1KC9ai/htV9xYh+UMDBjtuLDDEhxdwUaTc8zAvw2ugP04w9pVpT0uA==@kvack.org
X-Gm-Message-State: AOJu0YydOd4k36joGCWF4vCb018L8A4zpTFyDHd+9kBlf2BgwM0BTwmK
	wS9rFhKq/jS8gLGwsSM+vHSJQyFJ98VYihDhW0t4zeQHcibtCUEO5EoGEVFkhrO2smmgxUkAWT4
	p9fcyPkf2yKsE+8w6rU6PweOM59dXhM12+lPy
X-Gm-Gg: ATEYQzxw7v4Mw7WpVVaelfc7wPw9jZSxbMeeuza9D5neQrd+EDxXhnNjykc6lhtls1n
	TD0YbA4q0VH6eOejZpY/eqhy4sFtzpQpQUicDb0ces2VOk5sx+qLnbtlKSexmExtMQb1DhKSrnh
	uBfyE9J28GGy7SeoVn7qxrkOwV0o1nTJ1FlnfI94bhXNPW21odwTAugEolRnZUnl4XefWLJrTQf
	qIsyrmLWeA8tyjZH40PpDe6OedWBCyejlJGEpBcQ86XC+TE3zWaJGXZiDu2PYW6NbTyCJ7s7449
	DEniCw==
X-Received: by 2002:a05:622a:1920:b0:509:219f:8e37 with SMTP id
 d75a77b69052e-50939f53887mr14519361cf.3.1773202486401; Tue, 10 Mar 2026
 21:14:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260310073013.4069309-1-dev.jain@arm.com> <20260310073013.4069309-6-dev.jain@arm.com>
 <00f65edd-5b16-4f9e-a9fa-b923eba052b7@lucifer.local> <CAGsJ_4zMQReykifGVmXJEgPqORhRoFBKKJq_bjBzDGT5hfGGwQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4zMQReykifGVmXJEgPqORhRoFBKKJq_bjBzDGT5hfGGwQ@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 11 Mar 2026 12:14:35 +0800
X-Gm-Features: AaiRm52JwJxovBYjuRWLazi3MPILl1B7Q-7qpErbhd4bUK1nVgbGGsdlwXjx-PE
Message-ID: <CAGsJ_4wmrV0+wxiXAgEWRxBpv1QT9Sm__Pi+yREGvT9YH2n4uQ@mail.gmail.com>
Subject: Re: [PATCH 5/9] mm/rmap: batch unmap folios belonging to uffd-wp VMAs
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, axelrasmussen@google.com, 
	yuanchu@google.com, david@kernel.org, hughd@google.com, chrisl@kernel.org, 
	kasong@tencent.com, weixugc@google.com, Liam.Howlett@oracle.com, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	riel@surriel.com, harry.yoo@oracle.com, jannh@google.com, pfalcato@suse.de, 
	baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, youngjun.park@lge.com, ziy@nvidia.com, kas@kernel.org, 
	willy@infradead.org, yuzhao@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B0F72180002
X-Stat-Signature: xbaow9yaj1ts4d1ps4esgacetae91brq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773202487-562020
X-HE-Meta: U2FsdGVkX18f2RPy7S+9y4/kC0KhC1L+ppbyYO43swWdeb12OlLuYnOVjBkPg/Skr0sPRO5IRsvSMR/QtW0IZSgt4I0OO4pSZsR2Ky05quNLuqDTsky9pwEHC+EoebuRLaBAMt0T68n8/x57vOAl7nTKUb7du5qXJxy7KuM663UFUzZzTEzABoJkjKEkpbaAlBBSUoWQysSAm3ZiSgCRse+M63AX7a4e0LWU8sQ928aFoM7vS99bZXKMkEfI/mXqhz/vGgOgU4DUR/MSCEzv5Fc16SJ+3T5R4NclG65zU0PauiE694m/OnOJ5syvUIa+hw5O7AedcOyD50tTZuq4Zmw/CyBZPf+vDNxSXdEnhYWNz3uWVPH+ziYsHuYOHE+aGxu3bToBcvPE69LU7Dm/VOeza2yL2TiqHt3ncSZDz+b4B0CY+3fgl7RUJFRmG4nSYnD0TbJpdwLIlmWuUSS0JC/oK8jPW/VXeMBh/vO5Itp+ILakBJ+m9onxPfkBKBv4R3FXoNQfFRV6eK+2N1WGqDmCUSQ45J2BOxdHEAYZvVnhyXioO++jLjTz54jFKu9INnHUNTwQ9eM4uMws6OHtwQH37rZfg4iIvvzoCbzo+eIpRzzZ27gBqWux7yXBDMKSbIt7DVvE9eJdSAkrNcN07VYkw0PjKpfv9k48GaSBnqUl8H5z8J31MrgduMuq7jIBFIxcWLywl3zUY3gNCEd57ZpcATsdRntamcqXYk2ESO1hx4TqZqA6Y01buh1VcsvJTVAMi4Gowf5GCiw7K8e/gB89yGiXwdRd25S8Dy2XWR9/WBZ9//Wxejm/BRXWhl1gSeQ7y8OFnd7YBsycAbZquaMuMeyqgE0AtFzfiTKqK8i1zdvqyysfWiQlc4TnPRhGOlUASLgEGTD87ERxv0LPlyc6/jmU0jbfd4CevdsvTJMwe5AkMvwFBNw6newtHCBjMSnn0mBAg8JPrdndDeW
 PbRGHlyP
 mmgvuBKesunoMvrGdYWdkh2KlH77q3JUFYpU38mzWJvEM0dgJ1qtrmKjHOnvAkHFncxsX9nhT3udXnK/DmsWUA1pP0FPfBgJehebRyXHqbKcVm7F1Encd39+5qB4xUtaHLSLIQdzGCwBdu8JWS8FlP7sVEMbNLCj5VbwE3FmrhoFDDtbyckcN7fGfFEbMpsA8OqccvYdsq/Za9mhdNBl3YFA9o9COFkoUCS3OMmjHIrqe2X7bL8mW3tQQIlKPwWV+MA0EMNHAuswLoKX0swNMpdxmV/Df4tLEiLLksIn2WDzPQPJcVvSkz37sSaXJsm1qzjLWqKiyz6zsADm91xKV80S613lGBDRHxbC/1ZWjeqYRMs65wNNvjLvON9n5ub0ZpDWixKzQxKJlRAKoUuduYhwT+0pMG56ElhqDX512m9lDyRNlqiJRd20luJw/a6oJJ5uovi+svJMjnpp8WkrhedQFOEyeW+PlgiN8rhOt4oFyq4ynyGv2hra3qbHzM26LlKfQXwnVEpWH+DC0DdE7uL/JhGMX2UsEvJQM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 7:32=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Tue, Mar 10, 2026 at 4:34=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@ker=
nel.org> wrote:
> >
> > On Tue, Mar 10, 2026 at 01:00:09PM +0530, Dev Jain wrote:
> > > The ptes are all the same w.r.t belonging to the same type of VMA, an=
d
> > > being marked with uffd-wp or all being not marked. Therefore we can b=
atch
> > > set uffd-wp markers through install_uffd_wp_ptes_if_needed, and enabl=
e
> > > batched unmapping of folios belonging to uffd-wp VMAs by dropping tha=
t
> > > condition from folio_unmap_pte_batch.
> > >
> > > It may happen that we don't batch over the entire folio in one go, in=
 which
> > > case, we must skip over the current batch. Add a helper to do that -
> > > page_vma_mapped_walk_jump() will increment the relevant fields of pvm=
w
> > > by nr pages.
> > >
> > > I think that we can get away with just incrementing pvmw->pte
> > > and pvmw->address, since looking at the code in page_vma_mapped.c,
> > > pvmw->pfn and pvmw->nr_pages are used in conjunction, and pvmw->pgoff
> > > and pvmw->nr_pages (in vma_address_end()) are used in conjunction,
> > > cancelling out the increment and decrement in the respective fields. =
But
> > > let us not rely on the pvmw implementation and keep this simple.
> >
> > This isn't simple...
> >
> > >
> > > Export this function to rmap.h to enable future reuse.
> > >
> > > Signed-off-by: Dev Jain <dev.jain@arm.com>
> > > ---
> > >  include/linux/rmap.h | 10 ++++++++++
> > >  mm/rmap.c            |  8 +++-----
> > >  2 files changed, 13 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> > > index 8dc0871e5f001..1b7720c66ac87 100644
> > > --- a/include/linux/rmap.h
> > > +++ b/include/linux/rmap.h
> > > @@ -892,6 +892,16 @@ static inline void page_vma_mapped_walk_done(str=
uct page_vma_mapped_walk *pvmw)
> > >               spin_unlock(pvmw->ptl);
> > >  }
> > >
> > > +static inline void page_vma_mapped_walk_jump(struct page_vma_mapped_=
walk *pvmw,
> > > +             unsigned int nr)
> >
> > unsigned long nr_pages... 'nr' is meaningless and you're mixing + match=
ing types
> > for no reason.
> >
> > > +{
> > > +     pvmw->pfn +=3D nr;
> > > +     pvmw->nr_pages -=3D nr;
> > > +     pvmw->pgoff +=3D nr;
> > > +     pvmw->pte +=3D nr;
> > > +     pvmw->address +=3D nr * PAGE_SIZE;
> > > +}
> >
> > I absolutely hate this. It's extremely confusing, especially since you'=
re now
> > going from looking at 1 page to nr_pages - 1, jump doesn't really mean =
anything
> > here, you're losing sight of the batch size and exposing a silly detail=
 to the
> > caller, and I really don't want to 'export' this at this time.
>
> I=E2=80=99m fairly sure I raised the same concern when Dev first suggeste=
d this,
> but somehow it seems my comment was completely overlooked. :-)
>
> >
> > If we must have this, can you please make it static in rmap.c at least =
for the
> > time being.
> >
> > Or perhaps instead, have a batched variant of page_vma_mapped_walk(), l=
ike
> > page_vma_mapped_walk_batch()?
>
> Right now, for non-anon pages we face the same issues, but
> page_vma_mapped_walk() can skip those PTEs once it finds that
> nr - 1 PTEs are none.
>
> next_pte:
>                 do {
>                         pvmw->address +=3D PAGE_SIZE;
>                         if (pvmw->address >=3D end)
>                                 return not_found(pvmw);
>                         /* Did we cross page table boundary? */
>                         if ((pvmw->address & (PMD_SIZE - PAGE_SIZE)) =3D=
=3D 0) {
>                                 if (pvmw->ptl) {
>                                         spin_unlock(pvmw->ptl);
>                                         pvmw->ptl =3D NULL;
>                                 }
>                                 pte_unmap(pvmw->pte);
>                                 pvmw->pte =3D NULL;
>                                 pvmw->flags |=3D PVMW_PGTABLE_CROSSED;
>                                 goto restart;
>                         }
>                         pvmw->pte++;
>                 } while (pte_none(ptep_get(pvmw->pte)));
>
> The difference now is that swap entries cannot be skipped.
>
> If we're trying to find `page_vma_mapped_walk_batch()`, I suppose
> it could be like this?
>
> bool page_vma_mapped_walk_batch(struct page_vma_mapped_walk *pvmw,
> unsigned long nr)
> {
> ...
> }
>
> static inline bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw=
)
> {
>         return page_vma_mapped_walk_batch(pvmw, 1);
> }

Another approach might be to introduce a flag so that
page_vma_mapped_walk() knows we are doing batched unmaps
and can skip nr - 1 swap entries.

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 8dc0871e5f00..bf03ae006366 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -856,6 +856,9 @@ struct page *make_device_exclusive(struct
mm_struct *mm, unsigned long addr,
 /* Look for migration entries rather than present PTEs */
 #define PVMW_MIGRATION         (1 << 1)

+/* Batched unmap: skip swap entries. */
+#define PVMW_BATCH_UNMAP       (1 << 2)
+
 /* Result flags */

 /* The page is mapped across page table boundary */


Thanks
Barry

