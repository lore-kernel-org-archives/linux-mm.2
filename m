Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FD88103E197
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 914816B0272; Wed, 18 Mar 2026 11:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ECAF6B0274; Wed, 18 Mar 2026 11:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DB306B0275; Wed, 18 Mar 2026 11:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B14E6B0272
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:18:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 24EF21D976
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:18:52 +0000 (UTC)
X-FDA: 84559541304.26.D3CABB6
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1734840010
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:18:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jTT4QTtO;
	spf=pass (imf27.hostedemail.com: domain of mclapinski@google.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773847130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zJSXdmrQV+K79VmgmeCa/oY/xkKliZyOXrkXdpiFNNY=;
	b=L44PDMuMXk7BRvsYoozKlfeUWEPek+iW7OjDDbPBB/F5dyj55qcgk+SFrlDzij7ZiLSuk/
	L+cNGjE2OFIv1/7yGNmAGYc7+COKIsdk+g5fcvus0LiN3OKAfsM5zak5CXKktPh0B4ZUgn
	QfJFeI63rS6cBs6pb/lutQYVP7g64vU=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jTT4QTtO;
	spf=pass (imf27.hostedemail.com: domain of mclapinski@google.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773847130; a=rsa-sha256;
	cv=pass;
	b=mUtrrPzCzmHfKi6T9uoJNg+CzZ30mo+20Lq+XliTgD1ylxP/Usiw0sv+J6dOHZ+p1cvGvM
	Ps5v1fu8V+ep91zaM8OhVGr+LbjI4pbmy8ZorZjRnEJr+BD6X3IfWMnl9KHii95Lsy79T4
	TNe+E/gwdEQSlUvJ/1kUbukpmTWbwG8=
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-128ce536fe0so12233c88.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:18:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773847129; cv=none;
        d=google.com; s=arc-20240605;
        b=LhaFBPEKrwJLRtADsEwV744ntRTEfJvhDUQnw4+DxdPXf0OZudAXDcT1Tfd/paK0JB
         qSsJssRmIjq3kbtAtnZp8yqAWFC+r7xRKVqktb/KHU/1BlwJcWjs8+RXZ9dooAzX+fbz
         BIyNPu6pdE5Gm9NGWUsguZbg7FMtr2G050XN2GlyM6RlG41BTMAHnyPZgtDmhlete/VJ
         SQdJKgDZUztVbMydbty8Bqa9fMTLH3ilWqS99nS3UD11B8Fxu+q7iOd8rL7nk7Wmd5Tb
         LJrrR3v56dt8q7DS4nYLmlU+tdYsGYWxU5zFFMCvEYBtHVSlccqVH+v7oJuxyCcw4j09
         YUkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zJSXdmrQV+K79VmgmeCa/oY/xkKliZyOXrkXdpiFNNY=;
        fh=ZhoMx7Rfmccifyp3O8Di0MCw//nHwNsZ9kDpGtnznXo=;
        b=K9qXXLti4XbI+Web/9EkAbbEQfSsQ9r/81oXjjA0hyuBb2dC4WNRvGCpK4cJ91M8AC
         ten5hIDvcynrBDSodd5iRRpFL53xYHidJUofUqMdecGaif/2VvA7TIPmuxpiRC1PFyxS
         lna7eHSProsjDULnetv/8IKJtWSRzzpzJ83OTwXyclHWMBc4H3KHtu0hWVHA7KAgpRye
         uYGCB5340p9YSd5XUUpB+uTSNIeiPyDfIdbXpzqhU8Pq6qf4Je2sVNHoNMEF/octQLFe
         klKGAA51rRqmgq8VX1ucNAJrqZIcm7JfGHMYVP1GFCiGmzYYdbVW+3Q18JF4pirYmgZ3
         hqBQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773847129; x=1774451929; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zJSXdmrQV+K79VmgmeCa/oY/xkKliZyOXrkXdpiFNNY=;
        b=jTT4QTtOGcE7jZnDjBVmFX9P8nlZrP4692aGGVI88n6pgOzD1WbI6RO3+psYc0NbMq
         dRTWmFXgX8Idcv/wM6/Wehzvp1GsaV6ZVTmsHSqgKrU0T7cy61QJvWUHH02FphdppEOa
         Hmxj247BZWhHHtI+od7E081CkZJLRZmJnl1xNmz624N6vltVqoyhrbq1lLlr5A0bd9Ao
         nY5T6snCqRQdIQdAjiXy92/c4FQFpVPblvEYbkA4Bp5BXfIIXwN0deGhMFoANWh59k0w
         +X2xotQxo5ZfT2L9OgVMm+SHNsN9cey59+qNtRg1fVYMroHryufPcsK+1Z3liCeHHVbw
         r9TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773847129; x=1774451929;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zJSXdmrQV+K79VmgmeCa/oY/xkKliZyOXrkXdpiFNNY=;
        b=RQDhgvDwvWCEBZCMuaOGZoCUVwCXfmchymP8JowmdXLa4ktpJ/fUJMXpJKXbezZEam
         cA2/eVl43fqhHd/h7jRqnuTOf5mxwlFbsYy9x+fQzcb35W0Z2Dn8HKY/SoNd0qjad14r
         mvFgMBAtxqiqK8WHY7pvo5/hItcoXqc0SZG7wwXsZIkDuOzYaPRAwKyQKm6xdpEqm5qb
         pCe9UzT1mOzvqeZLopa7oB+9Ns9Vwbkpm5KjIdcGr01O82XK0HbgIp33IGOFZvJpK8QO
         P9+QRxefcwXJBQV6Q95wNDMJ4LlkswhYwJUebLktqASEK2W/SSqPlTcP8C0tnmyaTxdd
         QT0A==
X-Forwarded-Encrypted: i=1; AJvYcCW4CVAKZLzzQ11/3A8syfVKZ264LIh2QnHgNZMVyW5Az9C5q9K0FTy7VqvucUmiy6YavAVBRjXj8g==@kvack.org
X-Gm-Message-State: AOJu0YxK3qChVlfjWJwJCrAYgJgs0WhhPcOEU7zYgD1lgUZ+UJlkGG9I
	k2VA7x+P05SrzoRJsmmwfAn7K4veoEofZzzIqLwuyvwSkql3n8KVm4kGNFWXPIxX7VwsUALPkTC
	1F+OUsMi3GOwd5NUSwrJQnv4X2xzLj49c1Aa59HQ0
X-Gm-Gg: ATEYQzwJ9G/sefHZjjHFc5F0ajAqE2CSe+ENyXJKMBxAxSPWIW4wY2LPkNqVx8AigLE
	0LTumGjTscVxrAu8yvCzdHCgsgTZeb3VZO/dKfMPWqgj7I0B6a+OP++t0+Z3WoENzcrjoAZz7J9
	UYbVQWgct355FkI/Z3oZ+yWYYXBVS2LQ/cyLlZ19IS5/ZhhVgmmn0THJ4zH+W+YHSF0TUV6qUIm
	e5E1N8aIt8mFYYFXjeNSyvDoETpD2+okuzxQl1if0WTYajfLtiUtJfDaSprzEfey7kjWjSqeU0n
	J659YQ==
X-Received: by 2002:a05:7022:e1d:b0:129:e9f:4c09 with SMTP id
 a92af1059eb24-129c58964b6mr256844c88.6.1773847128064; Wed, 18 Mar 2026
 08:18:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260317141534.815634-1-mclapinski@google.com>
 <20260317141534.815634-3-mclapinski@google.com> <AD9E1B18-C813-480E-894C-FEEB51EE8A93@nvidia.com>
In-Reply-To: <AD9E1B18-C813-480E-894C-FEEB51EE8A93@nvidia.com>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Wed, 18 Mar 2026 16:18:36 +0100
X-Gm-Features: AaiRm531JN35mo1Mbe2KYhEsq0xf4gyOI0iQIVc6Zhg91-Z5R0b7EOHbR97JHD8
Message-ID: <CAAi7L5dSOxXETv-bYs4hJ1SfixMBQXS4fmfKs3SzVvQ=yY7oSg@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] kho: fix deferred init of kho scratch
To: Zi Yan <ziy@nvidia.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1734840010
X-Rspamd-Server: rspam07
X-Stat-Signature: 7cbzrearxcc6qi5r9ncyy5zssow48496
X-Rspam-User: 
X-HE-Tag: 1773847129-275354
X-HE-Meta: U2FsdGVkX18xnL1w1YS4a1VNAODqrOWPAYvSqYSJWHYs+u3ZvGnz2sI46NwhU+Vq7eLrMYmVIL8wjdb3WDBW9oMlKHuRWqLO19KYzmayuB32Gn3eiw/sHQJdw2ORPjjMSHVLbX6byvkmqZdzddraqFGagalszWkT/v3lNMyRxnpaltcD8OD9iX+GXGTtAQaKCaMq4ZbnmiduxQpgNdpwVBci3fdJeSDysCRn0A+rNuY2c/p3+5ekyO/eMwt4xpSgduv5rF6Z24Y1Juv4U++FeZwh6cF8B5P9Tf7nE90MGkuGeLwjPiCmJZdhNlzxXgsiWdnZfxgU1m53jryptPhWzzgBUMaogodW+4K+UxPRjQKYrR8x4EbxokI2aCoiqq/606VHLkiKeLVopoUH+HMtDiz9tJI3fMy3j/4QPjW/NJIx+yvA+L662zl5aTT90ZPIv+3aIYolNMnHgGj0MaLG00vqvbPM0GR4LEGcf4PFSNi0k2tvcTyc5MXQYY/z9hUhiUjKSRi1bAIwoGEOYfTAjtnaHgKpguYBsoPiWKO+YppksKrKLrgxYKgyDI8aDqxlqtHIOFKocU+hqkbdYDHuFPTEnnRl58/6lpSQ2vXKbbOcGE2cdoUKQu82qS6kKR/dHh9ZLi/tLA+k8FhQX1IKinLpCQyUIBs3+1uZRC37q6Q/kgFK19ZVv7oFKqAUob+buFNYAnW55gMM8rp5RMAkn+2lJ7+UYIzJGt9rkZSdIo/6aOHzLTvQDr2r7b74jpiIYE+tn7bdvH3wSSO3bgD61bqRQZJstytre87ZhrQmEx9PE7J1cs49U9rky3M8fa985SQVVXDyVMaP2IYqWHSj/K6NCycYO31iJk0SVLHV8JLpQQd4yhbZ+q9ZTOBXL/kO8y+R1Lwv02C9XVXaTz1O4I30wLSLFMtg0283aSXLa1+MVAAzNWhEIOFeU24HppNMuN5xjGkJ4FqwrEqpBzR
 JE8Iw4h8
 qNCGEr5f0HgM/IqdfMKD0j5rZvAMSLpRCVe9z9OQQIeGOZ1sd7ZnC6N1J9rHc0Tqm2VC0gcL0sSp415ZB/RwoO+pigC+9/jWRmqErDkm5JrchF7IDTCsT7+FWym7sgxPKVv60A/VdxdQD6jGxBLvszlJn4SrBU13T3pT/xZhT/SKz/xiO6RENKsTexcxMpRRF3OvKEmSNFWq5gmX07d8ixVZjjjNo9P33eYcFdf9/SYDaNEpVge8bscYKSJveyzvgRyAQsjiuU3G/7inF5WJqJoCx+mQHDJRAzVyB7oDO3X7Hz5d5fjbg+5NuOEI2gM9pfpqKQSnLt94X/V09/m3PCTZ1LI+qMVY2WObQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 4:10=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 17 Mar 2026, at 10:15, Michal Clapinski wrote:
>
> > Currently, if DEFERRED is enabled, kho_release_scratch will initialize
> > the struct pages and set migratetype of kho scratch. Unless the whole
> > scratch fit below first_deferred_pfn, some of that will be overwritten
> > either by deferred_init_pages or memmap_init_reserved_pages.
> >
> > To fix it, I modified kho_release_scratch to only set the migratetype
> > on already initialized pages. Then, modified init_pageblock_migratetype
> > to set the migratetype to CMA if the page is located inside scratch.
> >
> > Signed-off-by: Michal Clapinski <mclapinski@google.com>
> > ---
> >  include/linux/memblock.h           |  2 --
> >  kernel/liveupdate/kexec_handover.c | 10 ++++++----
> >  mm/memblock.c                      | 22 ----------------------
> >  mm/page_alloc.c                    |  7 +++++++
> >  4 files changed, 13 insertions(+), 28 deletions(-)
> >
>
> <snip>
>
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index ee81f5c67c18..5ca078dde61d 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -55,6 +55,7 @@
> >  #include <linux/cacheinfo.h>
> >  #include <linux/pgalloc_tag.h>
> >  #include <linux/mmzone_lock.h>
> > +#include <linux/kexec_handover.h>
> >  #include <asm/div64.h>
> >  #include "internal.h"
> >  #include "shuffle.h"
> > @@ -549,6 +550,12 @@ void __meminit init_pageblock_migratetype(struct p=
age *page,
> >                    migratetype < MIGRATE_PCPTYPES))
> >               migratetype =3D MIGRATE_UNMOVABLE;
> >
> > +     /*
> > +      * Mark KHO scratch as CMA so no unmovable allocations are made t=
here.
> > +      */
> > +     if (unlikely(kho_scratch_overlap(page_to_phys(page), PAGE_SIZE)))
> > +             migratetype =3D MIGRATE_CMA;
> > +
>
> If this is only for deferred init code, why not put it in deferred_free_p=
ages()?
> Otherwise, all init_pageblock_migratetype() callers need to pay the penal=
ty
> of traversing kho_scratch array.

Because reserve_bootmem_region() doesn't call deferred_free_pages().
So I would also have to modify it.

And the early initialization won't pay the penalty of traversing the
kho_scratch array, since then kho_scratch is NULL.

> >       flags =3D migratetype;
> >
> >  #ifdef CONFIG_MEMORY_ISOLATION
>
>
>
> Best Regards,
> Yan, Zi

