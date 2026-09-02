Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7EC6C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 15:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09356B00A4; Wed,  2 Sep 2026 11:19:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB0406B00A6; Wed,  2 Sep 2026 11:19:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99F6A6B00A9; Wed,  2 Sep 2026 11:19:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 637086B00A4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:19:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C1679A37E3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:19:14 +0000 (UTC)
X-FDA: 85169180628.04.7503DB4
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf06.hostedemail.com (Postfix) with ESMTP id C0D11180002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:19:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CmzgI25r;
	spf=pass (imf06.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788362352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1TYq5QMg6v1RnplPidvghW9LSaKei4XeKpOdsZpFXm8=;
	b=pRER8FXVCjDbuek/YKTIqFqC3t+UO+FU/ssStpSoUic5f6AlxJuvWsPzThKWQif1X3bKfk
	Xsfttj20NhVtBaAMYukLIhEaIXtMddEv7OISu0rT3/lQs6uSzCrQIm6R4nTq+yf7GHDNmN
	PYf+TQRtuxJ3gqR1hgTXYbk45BDNWxc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788362352;
	b=hGohfbmU7zq2kexE7K6fU7cIJWbDROtAiYIG/9+VYwnlBy+TgcjVdHgVQet33yQH2XEEHN
	XQMOqMSJVyO9p4GEtJsNPWe7ndqwXWVApr1M9G7jYpXXyjtz8pZv17bYWnFB27/LpWtoIB
	JGDFHsFrGPlB4jZazPyPtbQAbdFXCSA=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CmzgI25r;
	spf=pass (imf06.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-836c8bdac50so15393777b3.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 08:19:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788362352; cv=none;
        d=google.com; s=arc-20260327;
        b=ItfRTfpvar4C4I53uq84TJNB+34To6mmLuNH8Cxn4S0M0ymhdLyNVfh7EDjZcV0QZN
         GabvzLzHHTlbvuuWpKMPVDwPRhCBKLNfCO6v1KHtGDIKjPh/7JWPZ4py4rYJXvsadTs8
         xXVmTZBTmk2xduWola41ZYKyxdztskIyI10GGDnjTnnezuXD9u6klmXPdj62apE7cCvC
         6f7Mb+3+mYf08FD+tWnK0aFrT1cNnF4Zh2uvXQdLrW3BFDJxsQbulYXzvamq+bSXuHTq
         GLLVhlGAyti10/pEDWnXC15/Pf/vC4Prn1ZR6vWfwJ3tofZzCwiAtS3HqsTjw0zNCFQS
         BxcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1TYq5QMg6v1RnplPidvghW9LSaKei4XeKpOdsZpFXm8=;
        fh=SdaDnZ0/SFUwoCrho3y1lIGVvYSoIG8js+bKpHqgsQ4=;
        b=JX3WIuvHo7s1Dw5bnvS1EgkVcHssH7rWVIE2nRO2TAR2U2984uYCgBmiAIYsLDre4M
         aI3aDNaUqN4bwVRxqVZSYADWEe9geFcyRXfYceR+olRu5Xt1clyXQKTIxuaRD94VDHoA
         5GmYFoOsvmnqEK3PfZ2objnC0Hlx1K6F4U2tSZMNxh7RedLMPIkrjr5KMy1GhJBFSkWp
         cDQ1kknA9LNaeKmanj34fC7G7CgAjpjt1QKWKM4m3dwZPZhfaFYdC1waovqqGildqgsX
         crlo8uGh6V3sw+eQl26H8ySRbh5TZ0YWZrCd6yUgEr5Duls/IzWOg+GJqmEmf1SUGzQS
         oR/Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788362352; x=1788967152; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1TYq5QMg6v1RnplPidvghW9LSaKei4XeKpOdsZpFXm8=;
        b=CmzgI25r0xLhk1P39vPGQpfSNLAVxMUYZSHHsaS7mQqS7Z+5U5KefDDBfoOMXB6mfH
         PFlKRW7ZA0NnRfFnljSZ+JynRUuQksA++FpYNgrkSM2t/EDhm16eC4/uLmYcN5cWqrTq
         ztvOFPguG4ZdRiB1cYQItn3SGAWq65JHj/HWEnDe9i7fM2sbV8NLVCDB04yuFq4BipKF
         svc1wdvGYep9Cg3fAYOcvfemlAK3Tj5cDTIGPjDWVv/XfrSogQRinL3nKXBEMcZgcqSG
         cSnh84dQvNHgYHagcwTTfEHKi0YDUiI78TO8NFdgDWV4AhTDZsjGwfqfK9gcAvYS7227
         ISFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788362352; x=1788967152;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1TYq5QMg6v1RnplPidvghW9LSaKei4XeKpOdsZpFXm8=;
        b=j67J4TqE4r1rws6vnEv55+Bz845VsM0iXtoEYyKukVVBX2uRWrCVpyUXxb22XmWjYc
         wQJmTVlZADEm50tY0CcMF9x19ZNUYyMm6rD6fQp2bxTYtI9FXZzfhmq+KwSKdJ4/AeRf
         Lq8Tpzc22tB5i9YYB85xWjUzADQ0HUaMPokQi99zcNQBQS7Gk0vzMDAdGbAFEPxuY+Ks
         Pdee+F9SF/IOkO8dA/JCDTvITpBLhTvXAAUIQzwcoWHm3kdjeTB8qj0Mb8I8wqbc4cDV
         kG6gQFDqYePsSstJkWaH+2jBs3qmNkZSDoDzbeCxkmCqidi/Dkm5ndzMqLic8uE3dqq6
         cOFA==
X-Forwarded-Encrypted: i=1; AKwUvBwMV8fqzBYxJWNgtW9APxa0KKtHVaaU8uUbDUH1my6WoVC9A/BlvS3mIZg3qPVGdTyVPXdUfwON5A==@kvack.org
X-Gm-Message-State: AFuF++lKVn4mKmSkPAEwWsVZL5eRSwrGY90qdA7U5Rj0TuBx1BoAcn2r
	kg3vZEthhpQopZEMDjFwlNeyVYfkyfnz3FJZX6ryVq2iVyPkZKUdb+gFi9f80WP0uCqs5+V/RZR
	h5ZPL4YLmv7QMIbTELsSt9Oax5B9WfJQ=
X-Gm-Gg: AYBFou1MT4Jb3PQPdfGdSkFqg9mLVm3mldHfE/WLRE6lhpZcpvfYWOA9KM77tR/BpH5
	3mlAy+BdWbt6a9sbey2IFVEj1P3pcw53QECHR4flnLocEE4iqoyqSvt5SvkGbpXGpp3z6ALByJx
	2jRrypJi6pRH3ib4NpgaEIq3Qi9YHmmrgV86VqzhxWzFGrr254x19eKicdjff1PBlTG7LRf93jA
	uF/ZEbxIfTvaWcqAqE4Zr3ixqqFLh6i2hXMh9aedRw/i2SIEJ3VOXPLG87h2IcbpYC+o4n3AIDq
	izrhBF92ITD36UWQJo0d1Y7ZJ7unKFkiJX7qShsPXQ==
X-Received: by 2002:a05:690e:4416:20b0:667:e8a3:ebd4 with SMTP id
 956f58d0204a3-66f9b8f1121mr1700372d50.4.1788362351633; Wed, 02 Sep 2026
 08:19:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260901165237.1025973-1-ekffu200098@gmail.com> <apceSXvb6soT2U1-@kernel.org>
In-Reply-To: <apceSXvb6soT2U1-@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Thu, 3 Sep 2026 00:19:00 +0900
X-Gm-Features: AcwNN1V9ciQ0D0nld3_FQRlG2PvnTH89QuJfnWqJSFfiJB0i68XsB6to9qh8170
Message-ID: <CABFDxMHJ3zSbfRme=kuCEpJaVOBFRpsnerng=tOXh7Gk6QMcaA@mail.gmail.com>
Subject: Re: [PATCH] memblock: fix page count when preserving reserve_mem regions
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	Pratyush Yadav <pratyush@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C0D11180002
X-Stat-Signature: ffq1hnq8aaf4bag61amyrwrusqx8d6ob
X-HE-Tag: 1788362352-72678
X-HE-Meta: U2FsdGVkX18rHJ9iXW3AfthAp+bbaG/qQwHbD2hcYE7t9CSlVCeQGYJC4qUJ/HUpSfxw4LAB+VrGh5+WyaaR9Bt1yc8t7qt2MMOWLyZL27iZ1fpc9lpTwYs9DmY+ys+NwV84fdWL1P5dLC4047sK9W19IAS3kub2vgKXftPUWIPLaW9G4dhjuuOkfNKyc+0H9DLxdVp4/DgtBCYVfIib8n/rZHECW3DrW7QdBdy2OvbOUf35LbLliTSLZKYZvUGgSTb3RZFYj50kNVG8FRnzFZ7tS05Krj70fHC6E1rd8hSwfIRHSYvGXiOEWrCX1LJkRzZ8VUezKTnR2tzsxKZCqTedXnwoOV8DJk9dERwuMTRYwZiKvZB5EdfLB5khpvWk2ZYrZMgOXi6d330MabPMQpYg36AjqFdK4A+nRyi/FO01KlGS7iZ40pr+zS9N3XYqYWAauFncvdZZukOojMflYuzyqtvDs293pgrp88pAeUOpT0uZcR/eY3kBC/lYksgpcDLULmppCgiLh79Y9O/Yf9Tc4Fhky4GT2Wrd7/nY0c3p2zjj4DhXqUbzDZMFPot8THb3cPA+Uet5DyD1Znc7cKa0M0jhxZNSnhS4+G7vMXsDEn3beibs76X/u3WygHf8cuj5mPf782TeurgF8PguIr4RaalW22aN7x88+6g4hFTm4EnIgBN53oyezMrHwtMSpgYff+5XHCAdzDdPUUuQ37ZJAse85if2g2Fm0Z5wHm6u/V8oJcHJEVJaQnPuK1NUT7yzAEFlIg9JHxrdxb5nhqjkt24uXmrMWbHLNpMPgrhwG451+zrgwtc6VsY60Uo/+jHxxXUanNhnyvMC7SiDR+rZVkzJXgUr+5KHFT4ivivbcYYmz/7i4oMSrPVMpUHkhe6Zozzg8EEv0IJz/JrSqHvvexQibV1AaY3GAx2BxOjKLWDTzAZLsM+9XIqvkq9ljB3/EPleor/EdG/m+Yq
 K6DPDrsR
 uChKutwWHJ0UgOT8w0r/mh58zKXhCl8lY/XEDIVPRyEoy5eD1W8H0KZMwV4Hd9GkCBP3FgNjK1V0BtGjeSUS9fn2c4QfHynbjtJ+A1ClVZrjJjWq8tDVeXakhtklgCf6+FrlULXuuKc+BksUtCmbKKERBTLfQkDT9m0Jj50EW1f9iTiJSVIX4WPSgtuztxBo/y6/e7aPWnOeUpQiOd5eVnb3fMkMIQfYAHfSLXLuOtYY7WZKveI5lWnJfXLG+Ib9MlurkG21FjvKWPyJ/r6cWewUn6y+BOIERtCzMlIHj7CK3c5+UBra6ri53Ld24h2biE+AOPLaBfQMCACZZ4o0jwm6PnKApKOTZsYcM6Xhqg0STSsfWiRLq5zD/+xkkreDQdvQAYj8d+im+MdHYfkaULj1hvR/3TPGzcKTe61GmKv7qqHbTOR0N/BoenXbj33aJOZgtWl4mqQP4augiE//ntZBtJGy9CPuBn1zo/RZ+isxHqmo0fsuIiXjgzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Wed, Sep 2, 2026 at 3:49=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wrot=
e:
>
> Hi,
>
> On Wed, Sep 02, 2026 at 01:52:35AM +0900, Sang-Heon Jeon wrote:
> > When map->start or map->size is not page aligned,
> > reserved_mem_preserve() does not preserve the last pages of the region
>
> I believe it's the last page, not pages.

If the reserve_mem region is [6KB..13KB] and PAGE_SIZE is 4KB, it
spans three pages, but map->size >> PAGE_SHIFT is 1. Yeah, To be
exact, the last one or two.

> > from map->start to map->start + map->size.
> >
> > After kexec the new kernel reserves only the preserved pages, so the
> > last pages are released to the buddy allocator. But
> > reserve_mem_find_by_name() still returns the whole region including the
> > last pages, so they can be allocated while the subsystem is still using
> > them.
> >
> > Preserve every page the region spans so the new kernel reserves all of
> > it.
>
> If there are two adjacent not page aligned reserve_mem regions, we'll
> preserve them twice, or worse unintentionally unpreserve one of them on
> error handling of another.

Right, unexpected overlap could occur with this patch. Luckily,
overlap doesn't seem to break the system in the existing code..

> I think it's better to restrict the reserve_mem alignment to PAGE_SIZE.

I considered that direction as well. If it doesn't break existing
users, I'm all for it. I'll send a v2 soon. Thanks for your review.

> > Fixes: 8375b76517cb ("kho: replace kho_preserve_phys() with kho_preserv=
e_pages()")
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > ---
> >
> > QEMU-based test results
> >
> > - Booted with "memblock=3Ddebug kho=3Don reserve_mem=3D5000:64:oops"
> >
> >   # kexec -s -l /bzImage --initrd=3D/initramfs.gz --reuse-cmdline
> >   # kexec -e
> >   # dmesg | grep kho_preserved_memory_reserve
> >
> > 1) AS-IS (before fix)
> > [    0.188536] __memblock_reserve: [0x000000013ffee000-0x000000013ffeef=
ff] nid=3D-1 flags=3D0 kho_preserved_memory_reserve+0x3d/0x70
> >
> > 2) TO-BE (after fix)
> > [    0.076935] __memblock_reserve: [0x000000013ffee000-0x000000013ffeff=
ff] nid=3D-1 flags=3D0 kho_preserved_memory_reserve+0x3d/0x70
> >
> >  mm/memblock.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/memblock.c b/mm/memblock.c
> > index 777c69f05400..a17b1cccaf3d 100644
> > --- a/mm/memblock.c
> > +++ b/mm/memblock.c
> > @@ -2534,7 +2534,8 @@ static int __init reserved_mem_preserve(void)
> >       for (unsigned int i =3D 0; i < reserved_mem_count; i++, nr_preser=
ved++) {
> >               struct reserve_mem_table *map =3D &reserved_mem_table[i];
> >               struct page *page =3D phys_to_page(map->start);
> > -             unsigned int nr_pages =3D map->size >> PAGE_SHIFT;
> > +             unsigned int nr_pages =3D PFN_UP(map->start + map->size) =
-
> > +                                     PFN_DOWN(map->start);
> >
> >               err =3D kho_preserve_pages(page, nr_pages);
> >               if (err)
> > @@ -2547,7 +2548,8 @@ static int __init reserved_mem_preserve(void)
> >       for (unsigned int i =3D 0; i < nr_preserved; i++) {
> >               struct reserve_mem_table *map =3D &reserved_mem_table[i];
> >               struct page *page =3D phys_to_page(map->start);
> > -             unsigned int nr_pages =3D map->size >> PAGE_SHIFT;
> > +             unsigned int nr_pages =3D PFN_UP(map->start + map->size) =
-
> > +                                     PFN_DOWN(map->start);
> >
> >               kho_unpreserve_pages(page, nr_pages);
> >       }
> >
> > base-commit: dde94c26af59f5020adafafa08ece21ccd32590b
> > --
> > 2.43.0
> >
>
> --
> Sincerely yours,
> Mike.

Best regards,
Sang-Heon Jeon

