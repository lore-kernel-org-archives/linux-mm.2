Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAE25CCFA13
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 14:18:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 305AE8E0006; Sun,  9 Nov 2025 09:18:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DD198E0002; Sun,  9 Nov 2025 09:18:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 219B28E0006; Sun,  9 Nov 2025 09:18:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E33A8E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 09:18:55 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AA861B9FCA
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 14:18:54 +0000 (UTC)
X-FDA: 84091274988.13.9D2C9F5
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id CB04D4000D
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 14:18:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HaCN8Hes;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762697932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NSrLYa2dbPu1Sk4hzGvFs9D1jZAxpdigfTc1UtzFttE=;
	b=UWrOVIuBAljWQel685CY0obDdFGEGduoPb1575zxMnBsQ6QuXsbajJwjeyYA8Wauqczsqf
	ETPpyqD+IFZe/FwX1UAgcH/weTgquYSdv081/H5NICy49wkxqjRWYbhA+9RWvlmJ2swPJx
	w69b6j/sTTbaufJ/UFxGZ/S+m85Zfbs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HaCN8Hes;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762697932; a=rsa-sha256;
	cv=none;
	b=zD5V/VDdeJFhP1uXIHxKIJp3wVrjcl6kkKm4OacauFWHwF6cLp4Z/JqfdpmHxsdoYbaFwA
	dw8RjPSMZku7rtT/CiDjiZ0n8NdbKkrR9gcWmleYTAiaYvp25dk4vvcON63063mfkCYB/X
	NGxAk86djr0rWiFYvd4rCvJV/TCo6dI=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-640f4b6836bso3984960a12.3
        for <linux-mm@kvack.org>; Sun, 09 Nov 2025 06:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762697931; x=1763302731; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NSrLYa2dbPu1Sk4hzGvFs9D1jZAxpdigfTc1UtzFttE=;
        b=HaCN8Hes5N+477XcvMBSwlJI5DERHMG4VRLz1h/ewyk3RbgGlypVjcAG+QBlXNiuD9
         BXvO5TtfeB0q9EuxCKBHq8NIWIKBdarQw6ROfOkbTGWeVQQ3BnXhmSQiFQE5seCqriPK
         bWab7fdRe/8eUPuxsyn5gPD1p9GyIkI7GFWyRnRaZcg/4HrOjkVlpOEpVT+yXbKNA/oM
         X8rW+2q7jROcZrbP3lQwDlhTivzGMXmyDrL2eoaU7s3FtTJqeM6j26Da8L+jOHS/Ew8x
         uXWKU2xBSyQKnIrAjA1nAMSVUAHFKKzrQjfTTTq0ubwTm2lk1QeE8RZqr6aULer0hIxM
         tG4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762697931; x=1763302731;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NSrLYa2dbPu1Sk4hzGvFs9D1jZAxpdigfTc1UtzFttE=;
        b=s6O7XIKcjCsL6wW73vyUQF4IVW2mjpqHeKgc+sS/PRzlckgiR7lP9b4SMfabDKBZ3R
         8l6AmyrksZXRR0aFBBUpRZV0vduSnibX6PVOTe0WGjGpHzo7T5YaSJqKGW7ect66vG8Q
         9UGt2CEcU7yq+HzCF7u6/t8vkgNNX1q1g2MUqyQMvoNBjl+FF4azEpo9R5o+JhjOkwpv
         /miv/EvbKZ3Y10XA9RmqQbXCWtqGQjb+h2IPSi+CokutZKVcffGFacWhJ5rz6t8JpHe4
         RKpyXb1KnAK+HIav6jnCRfad6zCN73Jvdv4YCgzLprGn19f316wTNZGYhfbbwikfQqe+
         CeBg==
X-Gm-Message-State: AOJu0Yyhm+wYae6YOr7120Dsk1IKg742rCuQzIQjJc56D8gRgsmtSQ8f
	8NAaZ8oYmz+6RLF0EzZ7ItgUxCEF7Ofp2MCtiKYj/Wd2DdGjL1c77+1gZ8+RqNSXuG6Dd42Yic6
	nkGo5tkyX9yQG5Mi7LAjJx0bwLIwXndXXcpi0iMXFAg==
X-Gm-Gg: ASbGnct7QMEua2hfTyxjQSr0xstogNvSvcOdwrGHm1LuClnPX3wZWmfOqbP0c4XX3s6
	O82+duk0Z4HwuFXRYimCmDgGhhMgCYll6vpD7Eh/MrDcNDuYN1J8DG66OM4jsfS+8KMIpWmwKkY
	6im1GoNpUf35ESX91CeAWv6z2HidLq4W3UmKnL9U0/Ct8zq3sCGdwsmrPQuAxR+FRWLR9aYjH9j
	jUrA6QQJ4lXTG0sQnkrxxQV0FD3wZIYd8m/i/ZUVytMWHQ7vCxoIJIr99SQ
X-Google-Smtp-Source: AGHT+IEFDYvsYRL8O6CxREB+DW6VxZZXLsTpZLPIrxXNxvx3A3g34J7Gi7p7SIrZCX1x3uFDQOBusJmADrd7jl8WQdk=
X-Received: by 2002:a05:6402:4559:b0:63c:3c63:75ed with SMTP id
 4fb4d7f45d1cf-6415e6fedc3mr3643226a12.22.1762697930903; Sun, 09 Nov 2025
 06:18:50 -0800 (PST)
MIME-Version: 1.0
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
 <20251029-swap-table-p2-v1-13-3d43f3b6ec32@tencent.com> <CAGsJ_4xquj2Kbc2qu0vtY6Q+-q3sg56BgKEdPs8eHtKxLBk0gQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4xquj2Kbc2qu0vtY6Q+-q3sg56BgKEdPs8eHtKxLBk0gQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 9 Nov 2025 22:18:14 +0800
X-Gm-Features: AWmQ_bmqWlRo-KjW5ZzDR65b3A1_5mUxCTTaqf_DSjWOrCz23X79oa3MbbRzFFg
Message-ID: <CAMgjq7CDXh5OWy5BMXzNPCSuMQfODTdFPOhpCDGXrhisNfAGdg@mail.gmail.com>
Subject: Re: [PATCH 13/19] mm, swap: remove workaround for unsynchronized swap
 map cache state
To: Barry Song <21cnbao@gmail.com>
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
X-Rspamd-Queue-Id: CB04D4000D
X-Stat-Signature: uta3r1uk1hjmwwstuxmnfef3tkjruczq
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762697932-842151
X-HE-Meta: U2FsdGVkX1/IxOHIXNw35SAXsLUDlPszJh+vB6QUhTSyxnRqF1NDex/R29Axd3k43oIytODESOSVTemFK9PFUZ9A3UGXX5BzY6Ri6XvctRgPwFPnpjXYkHyL8AgLS7QQwKCm4Km+NB2hMq3Q3L+r3VQtkRBzfFQCVrRKR9l3yz0y3Qk8kuTUWYlAJbuTEe3Ezp0a2SOKOluebOunA846TJuSt67sXg3aS0g+JXF2D2Wvgubsc2bYLUcwQcTGz4NNFQq+mP+1UKu3fOTdk5J27idGOQ9xrKRGnvr/9UaiAVxxzwdJoz+00sBusYGcr2gvnrtUgWqmTDUufLx4qqciSXq2gbtrzv0vXhxYa3BSmnmTrQpmRaL+W1qO+UWK8D0u1x258Jsl1vVoFuierfRlwCYrXw67Ule64EQdZ+kYstcQfsWjnnwqph2WYtv6LFor5t1ifMaWKJms+YU4jPqURjfpE0tRHR68AkZLBZHU5/pQTAshLbYq5rFMZKYDSyFML0ThfwDg/MsQq21PBn5swz6h07k0/T4kBZj19ujl9pWAJ+lfoWGDe0CxeRHXRspx61G6UxoLd58BtD0cJz+ZZcRazQb6QnY1bwHDDDJZZ+4XiePjXS77nmfBVJnsW5ilzWb8gs3IkTSmCBeXpldsdnJSLvOboFtT3fm9dC2kBlGimSQifVPJ+ywxEv0CLhLlzsrzgcgsmjgNd5iG37ezQeN+pew59M/br65oU2fJ6NdaEY5HW2JysZPZ3lVEAuLPLFgZMQU4ttxJf3/iT2g7gEPkVnoccxdZWeq4CE5onDGtGo3ccApQt27kn1aaLaF0SAiDzdCn/epl7NIqtpdFHLmszwZ4qZ+t/3tH66Ni3vhRgr5a/cw6qwbsQ8bHUzMBht6/NK55XQ+9N+LtRjQSySa/e0+MyHrz8cDQGcQI1IgCNE25EWLNCD5bp1FIZFFQjJi/cDUYrE4rQiFQ/7/
 fUv42Dls
 mqdgqgewitBDIvocuBGIhQpw5KaOgLgbe7LHahrLLiaL/JO15pIyxLewp95vbIodyhWe/uUp3oWjsW8Pr+EuoxHm5T/fn0tuCdOiPet1L6Ndb3r4IUXMiytiNka3aDivRlcJf17G+0oANd61CvEc8+80Vp3ar4HI5qOvZeO4GNzVvwG/+8NYm0ezv55H0sTUD2ry1Z458eB6v1K/DB+DfArWAkNTw0kz7fUMYEiGqpOwuhh0dEqVU3+yVbwzaMsVx1r8hwX0QX8EamWkljk1n90rYwVqOBGHcLVtBYj4u2U0YvluPPLStFkf1juCrYs/X/PuwPIiXlLE5dbOzRLJOgE29CKnVkCvMvXwxu2M8kRXV7IetPGe20QfNiNoIaxsYwzb0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 7, 2025 at 11:07=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> >  struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask=
,
> >                                      struct mempolicy *mpol, pgoff_t il=
x,
> > -                                    bool *new_page_allocated,
> > -                                    bool skip_if_exists)
> > +                                    bool *new_page_allocated)
> >  {
> >         struct swap_info_struct *si =3D __swap_entry_to_info(entry);
> >         struct folio *folio;
> > @@ -548,8 +542,7 @@ struct folio *swap_cache_alloc_folio(swp_entry_t en=
try, gfp_t gfp_mask,
> >         if (!folio)
> >                 return NULL;
> >         /* Try add the new folio, returns existing folio or NULL on fai=
lure. */
> > -       result =3D __swap_cache_prepare_and_add(entry, folio, gfp_mask,
> > -                                             false, skip_if_exists);
> > +       result =3D __swap_cache_prepare_and_add(entry, folio, gfp_mask,=
 false);
> >         if (result =3D=3D folio)
> >                 *new_page_allocated =3D true;
> >         else
> > @@ -578,7 +571,7 @@ struct folio *swapin_folio(swp_entry_t entry, struc=
t folio *folio)
> >         unsigned long nr_pages =3D folio_nr_pages(folio);
> >
> >         entry =3D swp_entry(swp_type(entry), round_down(offset, nr_page=
s));
> > -       swapcache =3D __swap_cache_prepare_and_add(entry, folio, 0, tru=
e, false);
> > +       swapcache =3D __swap_cache_prepare_and_add(entry, folio, 0, tru=
e);
> >         if (swapcache =3D=3D folio)
> >                 swap_read_folio(folio, NULL);
> >         return swapcache;
>
> I wonder if we could also drop the "charged" =E2=80=94 it doesn=E2=80=99t=
 seem
> difficult to move the charging step before
> __swap_cache_prepare_and_add(), even for swap_cache_alloc_folio()?

Hi Barry, thanks for the review and suggestion.

It may cause much more serious cgroup thrashing. Charge may cause
reclaim, so races swapin will have a much larger race window and cause
a lot of repeated folio alloc / charge.

This param exists because anon / shmem does their own charge for large
folio swapin, and then inserts the folio into the swap cache, which is
causing more memory pressure already. I think ideally we want to unify
all alloc & charging for swap in folio allocation, and have a
swap_cache_alloc_folio that supports `orders`. For raced swapin only
one will insert a folio successfully into the swap cache and charge
it, which should make the race window very tiny or maybe avoid
redundant folio allocation completely with further work. I did some
tests and it shows that it will improve the memory usage and avoid
some OOM under pressure for (m)THP.

BTW with current SWAP_HAS_CACHE design, we also have redundant folio
alloc for order 0 when under global pressure, as folio alloc is done
before setting SWAP_HAS_CACHE.  But having SWAP_HAS_CACHE set then do
the folio alloc will increase the chance of hitting the idle/busy loop
on SWAP_HAS_CACHE which is also kind of problematic. We should be able
to clean it up in later phases.

