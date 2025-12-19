Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAC1FD7879C
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 16:29:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7A996B00C2; Fri, 19 Dec 2025 11:29:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0C726B00C6; Fri, 19 Dec 2025 11:29:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D04EF6B00CC; Fri, 19 Dec 2025 11:29:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCC776B00C2
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:29:29 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7442A1A0299
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:29:29 +0000 (UTC)
X-FDA: 84236756058.13.C0D60ED
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id 76DBB40002
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:29:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BEdnVURD;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766161767; a=rsa-sha256;
	cv=none;
	b=v+o0vgYcKBJ1V9GXTtDpbD6Lw4aBJ0QAmR2ncpoNWMAljrXM/POzWn+oW4qMU74FkJilab
	go3utGen9NAt12GMxvTXXc53hX2Sh73yviFcH3QyNW6HAcsliOQA7LqLwwUkkLzZXXcC2J
	XaqvKOTnSuydn28X9fXdSQzie/7OHzg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BEdnVURD;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766161767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HTr2kO3AH5aV44rgROvP5AMfNOh764zNrIB60vgO1zc=;
	b=iWggNU9CQg+4kPCOU9AbTJ0LX1dvDso97azEqVUCLtL0PWxlppHrO12MWSBOuMpCBWI94n
	1ku8o8nVHmRNy7yQDMiDV9H4ZHD9xTtf1yxXBuGukksCJIoNojUEAag7cSt7d3MgPZyHbm
	SQW3DeYJD/Up17uAOHy77gLbSERXFu0=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b7ffa5d1b80so239701266b.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:29:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766161766; x=1766766566; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HTr2kO3AH5aV44rgROvP5AMfNOh764zNrIB60vgO1zc=;
        b=BEdnVURDVtq3GAJj70itP0ok2yPe/LtPUZotVSIfzWn6Y2CeLJlMjnYXRY/LsSyR/l
         70nyPhAugLHhdJK9d81MVAIizeLJ+oL8jGP/h3vU1n858FHRQXTB6ApCW8Ej7ayxjBfz
         2liks2m5Y+agc7nSdmOTm1zu7+uPV1Fjb05rNT2KmuJEDpqlgquuvDQsdA5JQxoRwhJh
         nOuOEoMEGnlkkIXrP3s1PRmGhDK/cTL7p00N4gT4fTmUfBdjIexYaiaoHiGpH73epiHR
         h3T5IqUoIdChiqk1WCzy0qrput7UpxPUg0q1MfsO6Qkk393RlnPFK5kLJQqh0gxqVATA
         YpPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766161766; x=1766766566;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HTr2kO3AH5aV44rgROvP5AMfNOh764zNrIB60vgO1zc=;
        b=jgASX+bANMXm/iv/F23+sEuNCl/q3nvCAkygTRU44LpDk9kd1/OOSFxXY8J8CxIyMN
         gmlwIa+ordZNTjS9kypdcJNgGhWMuMFW6EDnQQrBF6jphJE8tH6IQy9RIFkiLeyEHooC
         aYlNeY6L1NMzYhVRPudoQwrFri72Kq2Vr+6XFFG2Fnp4MkbFHn1MXC39G/u7etduQPqw
         oyo960K9qI+LXwx4WpzsUQFVBmMonJZxMUQ1nfbU0gb2jk3gh91S/bBzTc/Dx4TZ20ng
         So1OUaFOQYA4raDCCoUtLbtqoee2Ee1kRPhFokh8cVRQDpOEvDvxnlxslTQmYQ7zJ9x2
         CvGw==
X-Forwarded-Encrypted: i=1; AJvYcCVvOBFxjfqnc+wDZzSDLFna0to6ImrfKXE/l9uX7zIYSzrvx6koN5CBjuHgmgbLMGVSV4e/vgQCaA==@kvack.org
X-Gm-Message-State: AOJu0Yws86Pb8LbLAUnnLdpNPrETzFTwftJs8hM+8QbQddWPGs/0TZAe
	/R2kqnEppdxkBS9BsIj2VJJdm+fzSxfkpn8puLd/gpitYgvIAkcA/s0s7JlUreeIa2TI4+jq6Rr
	j3VH48pVbGjqZgFGbVqrVqfJBHRPx39J9IQ4TJUL7wA==
X-Gm-Gg: AY/fxX5nBTHpPnRIV9k4zbq+L0eThvTY2PArzSl/P1C4mlW4B8OeYjJmerXVSdAXQ1j
	owmeYuFN3GlqnMl8dgDHHu2PdtKn7cRTKDMZRoBAjwfnoGFKrIEYfzBIIxPnNq4szgmR25hLQyE
	x4Y4tRtjHrii52onGtf5EAtsvSSjc5UtTMC9cWPcaic5LpvXhCPGQfNsMBLY61BG9TvWHQ83y6O
	649CTwpCIyj90xzKF0zT2vo+g1Z24rxlDj1fTWRJ9+vj+jU/6VMkos08jNUW22KjinAglXnWcI5
	6QW8XnextYRd+Rh91icttQSc
X-Google-Smtp-Source: AGHT+IGofUtuvCgN109UZF/PypAnhjEWl72HM9EdTQ1Wf1lQtHMZjSd97H5VK6s4AyDQ+AGPgIsUiET6kxIVyVyiVZo=
X-Received: by 2002:a17:907:1b15:b0:b76:2517:6927 with SMTP id
 a640c23a62f3a-b80371d46bbmr380301766b.43.1766161765744; Fri, 19 Dec 2025
 08:29:25 -0800 (PST)
MIME-Version: 1.0
References: <20251216084913.86342-1-epetron@amazon.de> <aUFJH9xzJXYOt_X8@kernel.org>
 <CA+CK2bDGvgcGJijAtSSa2k_FWjnZXm2jRiFd6Z9-XjEQ-Y68DQ@mail.gmail.com>
 <aUF4fsWwD9BswkFh@kernel.org> <CA+CK2bB2mn5b0N9gs1UavYLUQhbpVvdo702oHZa15E9OaZkKWg@mail.gmail.com>
 <aUUYprAotKYMiEs0@kernel.org>
In-Reply-To: <aUUYprAotKYMiEs0@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 19 Dec 2025 11:28:50 -0500
X-Gm-Features: AQt7F2pTd4wK3RRR8DuXPyTXo-EBR6g4IBaYL5wdaMP_cdEs620s97K7y3D5Xr0
Message-ID: <CA+CK2bD101cSC_7+OWkMei2QvUVjSaRLy+LboLe8Sz7KS3by4g@mail.gmail.com>
Subject: Re: [PATCH] kho: add support for deferred struct page init
To: Mike Rapoport <rppt@kernel.org>
Cc: Evangelos Petrongonas <epetron@amazon.de>, Pratyush Yadav <pratyush@kernel.org>, 
	Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jason Miu <jasonmiu@google.com>, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, nh-open-source@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 76DBB40002
X-Rspamd-Server: rspam04
X-Stat-Signature: y9ofmzr655kegoej4ihxfdipa47ofpqu
X-HE-Tag: 1766161767-105103
X-HE-Meta: U2FsdGVkX1+vtW6UPuKhu3CFbxcao25apWzN0OaL6D6Dxcdsnq4d34/NjSAEH3as7hQXNWVhC6SAW0mVKgyPrl2La/L6eE3EFrwt+sU44/3+fLg/ucUBTLn18iOonkn5Sz0TSpFJNsymDTRm3NjrPponhiI2uFjd5dj6gXSQe4axP+/Rb28A1KdPuar4i9AhSd90SLWmrn1a+0glHHOkIVg9ES8ND7aYNY+WR6zRV9UQ3uksy6xQONzrC2aTrs2i3A802TF2Pmm0bwZJz6sYTrqlDPT14HL18Tw3XXaDPprR1wyLaYh9f7pqnVn6TATRDY6rksTfQ9kJcTRsJh22Wlb2cWGAxQn/4xbQZlhMRdlALHj5NTDG0X3xZ8Kw3+ElHtN5fHEpKyQ3iQ3e36b3NKKUkuVxv40y+J6582JEJOy2dLuqwvL+VdvbURgqCf4wf1By9FN3bVduYeqxSkprix21G6fbxCS+0oRp3dtOgJQVIwtfKC6jbY04ipToR5zmZS9AEz1Qc6sPrk1JQVcpH3EaOMOm2V2gnullblrQYpEJ9q5FuDT0zxhcvpv0aunq1G4HK0znZoU5BDNwo7RZ0kXWaeJsKd7ierKTJydCFVIhsfj1N2t2zK5vbH/kDd5cWgeZlgWe2TRgg0X9rO2yz+P6zwKskeGHZYx3uSjEFNK+XQYcmI2TIUi9bWs2eKc6Muc6LjPez2DUqzvYQQ7bc68brHbr4g5Bgx2zdAzUlawrF0HvkYMfks/HqWzQ7MCm7vd6d3xDH3cKLjuypVrUwdyvJHSIxbIUmGLZOQ0bi3Gprw8lqV+SUbcDGyDPV61JMZ6akpQsU2+L3Sb4d5RGc8GXBDomv0E7MtjrpseyRSA+7/vZxB4PC6T59QpueWfJgnWKWegm70k7g3I1g6chbUNLvcTHmTwC/MU5aGbNZGe3Vv9ISqy1XRa5v+FsR2K0ybgFepM6YA9h3CtGrLG
 viyt+byf
 Gb5NhOkwZ2dR0evuBnXHEP0oLnFrIAUItiLLbNnc0UfDDvqkkRPoTV0Y1OVI55xXRGfisAorhFq0E773k1jQClERa6haVlETgcDy3bqvlWQjV/uMs8PsXS6ATYgryRMWY/OxqKypYeC1VUpvtoKb9qQ8PNA7JHYuq4Vf9igjBjtcICMuZPgincO+2H3XUo52OfiWMGn7B/fqYcqHqBd590Wh9XA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 4:19=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Tue, Dec 16, 2025 at 10:36:01AM -0500, Pasha Tatashin wrote:
> > On Tue, Dec 16, 2025 at 10:19=E2=80=AFAM Mike Rapoport <rppt@kernel.org=
> wrote:
> > >
> > > On Tue, Dec 16, 2025 at 10:05:27AM -0500, Pasha Tatashin wrote:
> > > > > > +static struct page *__init kho_get_preserved_page(phys_addr_t =
phys,
> > > > > > +                                               unsigned int or=
der)
> > > > > > +{
> > > > > > +     unsigned long pfn =3D PHYS_PFN(phys);
> > > > > > +     int nid =3D early_pfn_to_nid(pfn);
> > > > > > +
> > > > > > +     for (int i =3D 0; i < (1 << order); i++)
> > > > > > +             init_deferred_page(pfn + i, nid);
> > > > >
> > > > > This will skip pages below node->first_deferred_pfn, we need to u=
se
> > > > > __init_page_from_nid() here.
> > > >
> > > > Mike, but those struct pages should be initialized early anyway. If
> > > > they are not yet initialized we have a problem, as they are going t=
o
> > > > be re-initialized later.
> > >
> > > Can say I understand your point. Which pages should be initialized ea=
rlt?
> >
> > All pages below node->first_deferred_pfn.
> >
> > > And which pages will be reinitialized?
> >
> > kho_memory_init() is called after free_area_init() (which calls
> > memmap_init_range to initialize low memory struct pages). So, if we
> > use __init_page_from_nid() as suggested, we would be blindly running
> > __init_single_page() again on those low-memory pages that
> > memmap_init_range() already set up. This would cause double
> > initialization and corruptions due to losing the order information.
> >
> > > > > > +
> > > > > > +     return pfn_to_page(pfn);
> > > > > > +}
> > > > > > +
> > > > > >  static void __init deserialize_bitmap(unsigned int order,
> > > > > >                                     struct khoser_mem_bitmap_pt=
r *elm)
> > > > > >  {
> > > > > > @@ -449,7 +466,7 @@ static void __init deserialize_bitmap(unsig=
ned int order,
> > > > > >               int sz =3D 1 << (order + PAGE_SHIFT);
> > > > > >               phys_addr_t phys =3D
> > > > > >                       elm->phys_start + (bit << (order + PAGE_S=
HIFT));
> > > > > > -             struct page *page =3D phys_to_page(phys);
> > > > > > +             struct page *page =3D kho_get_preserved_page(phys=
, order);
> > > > >
> > > > > I think it's better to initialize deferred struct pages later in
> > > > > kho_restore_page. deserialize_bitmap() runs before SMP and it alr=
eady does
> > > >
> > > > The KHO memory should still be accessible early in boot, right?
> > >
> > > The memory is accessible. And we anyway should not use struct page fo=
r
> > > preserved memory before kho_restore_{folio,pages}.
> >
> > This makes sense, what happens if someone calls kho_restore_folio()
> > before deferred pages are initialized?
>
> That's fine, because this memory is still memblock_reserve()ed and deferr=
ed
> init skips reserved ranges.
> There is a problem however with the calls to kho_restore_{pages,folio}()
> after memblock is gone because we can't use early_pfn_to_nid() then.

I agree with the regarding memblock and early_pfn_to_nid(), but I
don't think we need to rely on early_pfn_to_nid() during the restore
phase.

> I think we can start with Evangelos' approach that initializes struct pag=
es
> at deserialize time and then we'll see how to optimize it.

Let's do the lazy tail initialization that I proposed to you in a
chat: we initialize only the head struct page during
deserialize_bitmap(). Since this happens while memblock is still
active, we can safely use early_pfn_to_nid() to set the nid in the
head page's flags, and also preserve order as we do today.

Then, we can defer the initialization of all tail pages to
kho_restore_folio(). At that stage, we no longer need memblock or
early_pfn_to_nid(); we can simply inherit the nid from the head page
using page_to_nid(head).

This approach seems to give us the best of both worlds: It avoids the
memblock dependency during restoration. It keeps the serial work in
deserialize_bitmap() to a minimum (O(1)O(1) per region). It allows the
heavy lifting of tail page initialization to be done later in the boot
process, potentially in parallel, as you suggested.

Thanks,
Pasha

