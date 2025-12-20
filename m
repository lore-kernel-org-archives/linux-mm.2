Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 216E2E668B4
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 14:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7521A6B0088; Sat, 20 Dec 2025 09:50:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FCCC6B0089; Sat, 20 Dec 2025 09:50:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DDF56B008A; Sat, 20 Dec 2025 09:50:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C6806B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 09:50:25 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ECE341405E0
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 14:50:24 +0000 (UTC)
X-FDA: 84240135168.15.B477124
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id E928616000D
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 14:50:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="K2vru7/K";
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766242223; a=rsa-sha256;
	cv=none;
	b=lk7XWDWpw5I+o5fC8waj0lu4VZRDgLNtB5c43G1lGlocnXPngQued4o4WD/hlJX+CloSDV
	ALUcs/0oDY5FUNhEiyk1hztOLKJ8m6dhLrOMaB66+tkoLIa7oBFo6Rw/fvPhHsL3rJfsDa
	fbgaIy9G1Z1JkK81Nbe53NwBhl9qxVs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="K2vru7/K";
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766242223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Goy8IvAF5EH1SjhL5f9/XSFbPZ8S1XtNVpjt6+v7B50=;
	b=nTvim6zWOLBAeeGaEEuQRNKA7l0AW4ywILlOHaSoQcTYr5FAXISsTfDn0SbkHvh2Wz6n0G
	Ycr9Z0PUYC7Mdb5m3pOHkGOybDs7wLYepHosboYzg3zjNeNvfp6FzuQ2ThPZtLQ5cVIbyR
	pL/486d19OzVBqzn5qKqM1nSKY2zyiQ=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-64b8e5d1611so2459876a12.3
        for <linux-mm@kvack.org>; Sat, 20 Dec 2025 06:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766242221; x=1766847021; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Goy8IvAF5EH1SjhL5f9/XSFbPZ8S1XtNVpjt6+v7B50=;
        b=K2vru7/KRZTNEclXRFpFs0Hm+JYurIA4HTZ5QTjyC1typGPgKp7bU660QQlpdWnalM
         MbVPbwqMkoTXk+B+AOu/4NkdA9z06YNMM5TLIHqHE5Hy05K0X/SbECXWphvBq9TnJiQW
         WXwuFxdu7awlX2cl7VBI8nVtz52gA47wct5KGZQeWWkoVHROJsfDCKTDzyFzuWWKay+r
         1x5mmjgs8TXsPdT/NtNJB8ZhrCgPQfZGlw19y36oiygtAp+kUiBi0AaO8nIn5mSi8Fj8
         +tp3eEh+xAsvmElQN1acHlxhVfsKC220nO+7Qu0laZ8kBBbW+qXqP/sTG3f8+VeJDX52
         Eiow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766242221; x=1766847021;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Goy8IvAF5EH1SjhL5f9/XSFbPZ8S1XtNVpjt6+v7B50=;
        b=HBuJQ/Lmp7sQc13tBaeA96Hf6/kGON2qo8l0UlaBQsvFTXWRp+nZNN/ZNzbfTR+T9v
         ekvSpHN+R/5JuPVktpBiSAGF3MwlLAIbI7xj9jH+FHq/yGMjAgU4GgK48bIU74UH3roc
         5/JeH+cooWdZ+St6LX4VQ193BP/A9rg0MiQLdtoxq3pYnAliUjPP2p0TAy0bGo/3Yqam
         Krn0D1LZd9g6Z53w10vk9iN3wbM5WXLfa/hLxwjimz1T3JojMS6D51CWQq5tjHw3CotL
         b4Xu05B6MjcA9iUTRvyjbi1hwyflKTklYovtrWKXNJ+czdstXe6+M/myaC33slawNqmZ
         Kudg==
X-Forwarded-Encrypted: i=1; AJvYcCVeSe7K/5XS49LfOAdO0GmagXyWbHnYH/l+wlwCLjVuGqjdB71WaffhDG0koBGyg56mfHY9t1TbGw==@kvack.org
X-Gm-Message-State: AOJu0YxIlpYEIA7A74AmFao3lCm9KG0j55xQw/bS1BUoVXq49WAzYbcy
	7DCMYAUkAjFejFg5I9XcjSkCr0SG0VAkVVPRRS8yJalnq53jrVmQuUzkS9ImMs6R16B2V/8wUoj
	EGk4xI5Fi9AoO+JpijLouZMEdpU4vrYrkMZSGgrNEFg==
X-Gm-Gg: AY/fxX5xdhubTX4MKxiyqIpoPjwb0v4qp24Be8ak7/hroP6OL9UEdqDemISrJ5D76nJ
	zVW2WC0Q4q+uAdoLLoj//oL2NUBls3EIBcqPax+JMY86dd/1Xqz7zz9ACL4ivGzvJcoIPKHGo6Z
	eedCt8E0RGeV9LFqTzRG+JJi60ovHOGhCzg18blEVEbHIDBw7YlnRCEQkbq29BiX+YVN0MvdF4u
	Wmz4GS3hzN5uNZHqpKGMRz7N6MSboKHt3AyRINw5ccto8VccRhwWqshjpjeJ3BaZ1ux3jLsOsQA
	o0Sq+IIXg5OEAA0lGhcKNvzMou7e4DXlAjbMOKdLkDdUnlQDZkaVSnRaAWbJrw==
X-Google-Smtp-Source: AGHT+IHIVqx9ytn5gAi5USUsY1jHhg2U2WSPQJtGGGCkUnwGVGj9YPZ5VMAqtf8TXFny2QtHU4UHSdIoz7ul+hi7Q0g=
X-Received: by 2002:a17:906:794e:b0:b5b:2c82:7dc6 with SMTP id
 a640c23a62f3a-b80371a71c3mr658870566b.40.1766242221134; Sat, 20 Dec 2025
 06:50:21 -0800 (PST)
MIME-Version: 1.0
References: <20251216084913.86342-1-epetron@amazon.de> <aUFJH9xzJXYOt_X8@kernel.org>
 <CA+CK2bDGvgcGJijAtSSa2k_FWjnZXm2jRiFd6Z9-XjEQ-Y68DQ@mail.gmail.com>
 <aUF4fsWwD9BswkFh@kernel.org> <CA+CK2bB2mn5b0N9gs1UavYLUQhbpVvdo702oHZa15E9OaZkKWg@mail.gmail.com>
 <aUUYprAotKYMiEs0@kernel.org> <CA+CK2bD101cSC_7+OWkMei2QvUVjSaRLy+LboLe8Sz7KS3by4g@mail.gmail.com>
 <861pkpkffh.fsf@kernel.org>
In-Reply-To: <861pkpkffh.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 20 Dec 2025 09:49:44 -0500
X-Gm-Features: AQt7F2pK4XT9_pgkJJh3fHmDqAK72t11dkqY99si46dJ87InO_jQlAkNaSjE-J0
Message-ID: <CA+CK2bA1kYCf0BwhX3Sg9Ur82nK-7HPzs0sg6xbVWFAJaZLhpw@mail.gmail.com>
Subject: Re: [PATCH] kho: add support for deferred struct page init
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Evangelos Petrongonas <epetron@amazon.de>, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jason Miu <jasonmiu@google.com>, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, 
	nh-open-source@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: E928616000D
X-Rspamd-Server: rspam04
X-Stat-Signature: zcx7q7aq7kf1jmbpkagrqoq79qd8bzh8
X-HE-Tag: 1766242222-855536
X-HE-Meta: U2FsdGVkX19MIFdIorL7tCnUneSlCbaR1amfp+zMDemZ6gXUAUsT0NxILr0asWua9dtlkB1f2M53bLtGP+Bcsd+fxvHysdqg7pCTkryYHOH1gvJVDUrfGabGj8MH/mCBHDYMPddraRr3BEPhGR2GB0klQNiZRTf8aDHzM5i0T5+ISUJXzChCKgsC8vgm8eRFuxmXQimfnP70Wh8g0LSdNMTgSw7lBQgXigDygkhJBbFDa5CMlYQo9cXcSob0gsKsHZsOKjZnv3cyKJst4LqFZJB2jqdlN1MnuDo+FKHQ6rm1mGdZfi+HEgZVhpx7sKUxjzFuO5oqCa3ZSFTih/D2xOcQDTOWScSp2XdkhWCwEA+r//mZJAYMrfFvNqjCPAWyD2t7bktXWaYNq9uvdNOcKDV+Gc6GD1GoPhhrY/70BdQdl1WF+Aln1pYXjOaliPunspe3oZ6sG+IRKGTFm5jnqauhB81f92zbxwoWMWGGhCsLJo0bEjdYkd3/ONtLerScU8cJPMVthq88yOkj6zh5z4VvFGP6RQt2I/H2NA5Ka/49z/YH1gLQebjIrMSR4J1IMXMjHqfVfA1D963Vj+ZNaqtzfSsbMO7z5P9npJOHFpKbSp0RUqiNVdBP21dUdHgSCG7P6WEPlyvWXxhsC/zujrC93xUtr7fQ/gPJafeARwM8wDi/qdKg4q/b/9AM5Em+mdqmV5ZTIWx8k4NgKOTfZZXBKFgfDVtYEGcThJJLY814OR9uoEAJwpIwv5TYPqnrRt9YCehVsLX9ltWf7tQw6Zf64L5Lol+mX9dvCuo1CxgH+GYYPdujkuZQLfKofYo/Roqsa1/fvvgr/WNVwYp3hQ17o562EsYghx5IdLhmDUK1askzERie6j9DGxPB5/VOAkcaYABZ9RzqmSE9sHsYVcrE+nhAwQUw6hRH+uFyh+GKXajwweFaqKZSgoEtnGwOTYHqLTN/u931Zs5/OtG
 u/cQcP/L
 gTnBqXMmsIXvxJKfxDutpr0hxCmAwEhFscx8dxASpYmLOfEq6YDuBsNu8lnA0OUVlx/v++c5V7rg6FdNccr6zry+CiIaye50UnHBZ17SPQtVoyLBlCOTjrkH4Z+F3mxJPPyeTYt8XTwGRDPQewyGTcXC6a3aPkrHyBsdgP1YTGWXxEiTWsygdUu0WOnYvuHlIwd5G4KJuYlHRdBc+ACbwdm+8xA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 10:20=E2=80=AFPM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>
> On Fri, Dec 19 2025, Pasha Tatashin wrote:
>
> > On Fri, Dec 19, 2025 at 4:19=E2=80=AFAM Mike Rapoport <rppt@kernel.org>=
 wrote:
> >>
> >> On Tue, Dec 16, 2025 at 10:36:01AM -0500, Pasha Tatashin wrote:
> >> > On Tue, Dec 16, 2025 at 10:19=E2=80=AFAM Mike Rapoport <rppt@kernel.=
org> wrote:
> >> > >
> >> > > On Tue, Dec 16, 2025 at 10:05:27AM -0500, Pasha Tatashin wrote:
> >> > > > > > +static struct page *__init kho_get_preserved_page(phys_addr=
_t phys,
> >> > > > > > +                                               unsigned int=
 order)
> >> > > > > > +{
> >> > > > > > +     unsigned long pfn =3D PHYS_PFN(phys);
> >> > > > > > +     int nid =3D early_pfn_to_nid(pfn);
> >> > > > > > +
> >> > > > > > +     for (int i =3D 0; i < (1 << order); i++)
> >> > > > > > +             init_deferred_page(pfn + i, nid);
> >> > > > >
> >> > > > > This will skip pages below node->first_deferred_pfn, we need t=
o use
> >> > > > > __init_page_from_nid() here.
> >> > > >
> >> > > > Mike, but those struct pages should be initialized early anyway.=
 If
> >> > > > they are not yet initialized we have a problem, as they are goin=
g to
> >> > > > be re-initialized later.
> >> > >
> >> > > Can say I understand your point. Which pages should be initialized=
 earlt?
> >> >
> >> > All pages below node->first_deferred_pfn.
> >> >
> >> > > And which pages will be reinitialized?
> >> >
> >> > kho_memory_init() is called after free_area_init() (which calls
> >> > memmap_init_range to initialize low memory struct pages). So, if we
> >> > use __init_page_from_nid() as suggested, we would be blindly running
> >> > __init_single_page() again on those low-memory pages that
> >> > memmap_init_range() already set up. This would cause double
> >> > initialization and corruptions due to losing the order information.
> >> >
> >> > > > > > +
> >> > > > > > +     return pfn_to_page(pfn);
> >> > > > > > +}
> >> > > > > > +
> >> > > > > >  static void __init deserialize_bitmap(unsigned int order,
> >> > > > > >                                     struct khoser_mem_bitmap=
_ptr *elm)
> >> > > > > >  {
> >> > > > > > @@ -449,7 +466,7 @@ static void __init deserialize_bitmap(un=
signed int order,
> >> > > > > >               int sz =3D 1 << (order + PAGE_SHIFT);
> >> > > > > >               phys_addr_t phys =3D
> >> > > > > >                       elm->phys_start + (bit << (order + PAG=
E_SHIFT));
> >> > > > > > -             struct page *page =3D phys_to_page(phys);
> >> > > > > > +             struct page *page =3D kho_get_preserved_page(p=
hys, order);
> >> > > > >
> >> > > > > I think it's better to initialize deferred struct pages later =
in
> >> > > > > kho_restore_page. deserialize_bitmap() runs before SMP and it =
already does
> >> > > >
> >> > > > The KHO memory should still be accessible early in boot, right?
> >> > >
> >> > > The memory is accessible. And we anyway should not use struct page=
 for
> >> > > preserved memory before kho_restore_{folio,pages}.
> >> >
> >> > This makes sense, what happens if someone calls kho_restore_folio()
> >> > before deferred pages are initialized?
> >>
> >> That's fine, because this memory is still memblock_reserve()ed and def=
erred
> >> init skips reserved ranges.
> >> There is a problem however with the calls to kho_restore_{pages,folio}=
()
> >> after memblock is gone because we can't use early_pfn_to_nid() then.
>
> I suppose we can select CONFIG_ARCH_KEEP_MEMBLOCK with
> CONFIG_KEXEC_HANDOVER. But that comes with its own set of problems like
> wasting memory, especially when there are a lot of scattered preserved
> pages
>
> I don't think this is a very good idea, just throwing it out there as an
> option.
>
> >
> > I agree with the regarding memblock and early_pfn_to_nid(), but I
> > don't think we need to rely on early_pfn_to_nid() during the restore
> > phase.
> >
> >> I think we can start with Evangelos' approach that initializes struct =
pages
> >> at deserialize time and then we'll see how to optimize it.
> >
> > Let's do the lazy tail initialization that I proposed to you in a
> > chat: we initialize only the head struct page during
> > deserialize_bitmap(). Since this happens while memblock is still
> > active, we can safely use early_pfn_to_nid() to set the nid in the
> > head page's flags, and also preserve order as we do today.
> >
> > Then, we can defer the initialization of all tail pages to
> > kho_restore_folio(). At that stage, we no longer need memblock or
> > early_pfn_to_nid(); we can simply inherit the nid from the head page
> > using page_to_nid(head).
>
> Does that assumption always hold? Does every contiguous chunk of memory
> always have to be in the same node? For folios it would hold, but what
> about kho_preserve_pages()?

NUMA node boundaries are SECTION_SIZE aligned. Since SECTION_SIZE is
larger than MAX_PAGE_ORDER it is mathematically impossible for a
single chunk to span multiple nodes.

> > This approach seems to give us the best of both worlds: It avoids the
> > memblock dependency during restoration. It keeps the serial work in
> > deserialize_bitmap() to a minimum (O(1)O(1) per region). It allows the
> > heavy lifting of tail page initialization to be done later in the boot
> > process, potentially in parallel, as you suggested.
>
> Here's another idea I have been thinking about, but never dug deep
> enough to figure out if it actually works.
>
> __init_page_from_nid() loops through all the zones for the node to find
> the zone id for the page. We can flip it the other way round and loop
> through all zones (on all nodes) to find out if the PFN spans that zone.
> Once we find the zone, we can directly call __init_single_page() on it.
> If a contiguous chunk of preserved memory lands in one zone, we can
> batch the init to save some time.
>
> Something like the below (completely untested):
>
>
>         static void kho_init_page(struct page *page)
>         {
>                 unsigned long pfn =3D page_to_pfn(page);
>                 struct zone *zone;
>
>                 for_each_zone(zone) {
>                         if (zone_spans_pfn(zone, pfn))
>                                 break;
>                 }
>
>                 __init_single_page(page, pfn, zone_idx(zone), zone_to_nid=
(zone));
>         }
>
> It doesn't do the batching I mentioned, but I think it at least gets the
> point across. And I think even this simple version would be a good first
> step.
>
> This lets us initialize the page from kho_restore_folio() without having
> to rely of memblock being alive, and saves us from doing work during
> early boot. We should only have a handful of zones and nodes in
> practice, so I think it should perform fairly well too.
>
> We would of course need to see how it performs in practice. If it works,
> I think it would be cleaner and simpler than splitting the
> initialization into two separate parts.

I think your idea is clever and would work. However, consider the
cache efficiency: in deserialize_bitmap(), we must write to the head
struct page anyway to preserve the order. Since we are already
bringing that 64-byte cacheline in and dirtying it, and since memblock
is available and fast at this stage, it makes sense to fully
initialize the head page right then.
If we do that, we get the nid for "free" (cache-wise) and we avoid the
overhead of iterating zones during the restore phase. We can then
simply inherit the nid from the head page when initializing the tail
pages later.

Pasha

