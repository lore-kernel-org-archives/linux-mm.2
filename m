Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D809E66886
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 03:20:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CC3E6B0088; Fri, 19 Dec 2025 22:20:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14FFB6B0089; Fri, 19 Dec 2025 22:20:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05BBC6B008A; Fri, 19 Dec 2025 22:20:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E98726B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 22:20:10 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 955FE56838
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 03:20:10 +0000 (UTC)
X-FDA: 84238395780.06.3958A49
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C6E2AC0011
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 03:20:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="d3OaU/Od";
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766200809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1SKx+S0FkyJgsVAeCS9CdFTq8gPlDnAtjpP2X9NjBVc=;
	b=HnzLeQThLzkY24n8gXiLFCmokbbVSJh2M3EQt9fAeYoAy8bQm3a0eK8wfI81Yws5yrxWbC
	lY5v3hlQdcHkJxNW+AFTl6SszuhiVGzdbyNyeO6Aw1Yr94SrOntx+/axrrck4sxsNukkJD
	k8oJ6Z2ibGibqHvPiXhQhsy85tremig=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="d3OaU/Od";
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766200809; a=rsa-sha256;
	cv=none;
	b=b2CgvXHETz+X5j7mVnc+2I48ZQUfWwq0/ikygLHgQiarszIhiP4wKVcb00+wAmkUEpR6SX
	7nWLJPvBDZisBDj/wfJdKLRT2i+30x/oiZLrC9ODIDXgCI6atw+d0y87DWdw6kezP4sNAL
	hR6VQFM3j/gv86W/InLJirAxyIH2eIU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BA77043B58;
	Sat, 20 Dec 2025 03:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9279CC4CEF1;
	Sat, 20 Dec 2025 03:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766200807;
	bh=PQoYiqwGtHkDFoeLJkBa9fjc7yrVcV49QT03Es5KPS8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=d3OaU/Odir3KCpAeDg2VtrL0s7Tv4VK4KjGhQzLhaCCeBuaKhbN4EK3PylJb1AVGt
	 otpqz1foWorLZpdgH2IeuBbJ0btf4gFfX7Hhn/GNTqPDA0kWpByy5CM2dvWC2Xmbqh
	 +FJUWBoL4DtkZT0Cut3hYTwiF/MegdUUg3j0HLswbeUt6zLVTLzbh7Kl1Sg5ilDPQu
	 MmfJRxuGDJ+asd2YsQn5erxv803SlEHiFcPy+0N/vof1w2zlJqORme2X0hu97df65c
	 Iial1U/dJo/crLdmQb6xJgc6c7DajZtP8Zv7MQ7+RyfxxTytYf0bA8mUPs1xwqPXGC
	 e9gOsckGcCkzg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>,  Evangelos Petrongonas
 <epetron@amazon.de>,  Pratyush Yadav <pratyush@kernel.org>,  Alexander
 Graf <graf@amazon.com>,  Andrew Morton <akpm@linux-foundation.org>,  Jason
 Miu <jasonmiu@google.com>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  nh-open-source@amazon.com
Subject: Re: [PATCH] kho: add support for deferred struct page init
In-Reply-To: <CA+CK2bD101cSC_7+OWkMei2QvUVjSaRLy+LboLe8Sz7KS3by4g@mail.gmail.com>
	(Pasha Tatashin's message of "Fri, 19 Dec 2025 11:28:50 -0500")
References: <20251216084913.86342-1-epetron@amazon.de>
	<aUFJH9xzJXYOt_X8@kernel.org>
	<CA+CK2bDGvgcGJijAtSSa2k_FWjnZXm2jRiFd6Z9-XjEQ-Y68DQ@mail.gmail.com>
	<aUF4fsWwD9BswkFh@kernel.org>
	<CA+CK2bB2mn5b0N9gs1UavYLUQhbpVvdo702oHZa15E9OaZkKWg@mail.gmail.com>
	<aUUYprAotKYMiEs0@kernel.org>
	<CA+CK2bD101cSC_7+OWkMei2QvUVjSaRLy+LboLe8Sz7KS3by4g@mail.gmail.com>
Date: Sat, 20 Dec 2025 12:20:02 +0900
Message-ID: <861pkpkffh.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: uairkku8w63cprzkq9yuuybbgah5nc89
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C6E2AC0011
X-HE-Tag: 1766200808-199731
X-HE-Meta: U2FsdGVkX1+nbG9ac8pSLIAKB36o2slpRzNmGifDZlhAG8F/PAWg//KZQCOAnbH6o0uHuEn9z7gihIGxOkueR3Oo/0HF+J33Ba3UF+yG9xf+cehRt/axPvD6KahjvZ8CB2qPVpQgNgeLbmhCDUoZllcycW/q5WXimsbArQwP92qvLxAbbd3Ew8Orlc8YHU9zVkpyaHnWLT0CN74+cMGVEETD03D8rovWaJU/SF1aDSQ76ZP6sG2XKD51cGs5yTPtAkF2mY1EG0UNb46bL7c0robOy6n/IsmbgB5njVlEsvrjvJ/lxibsPvmeiXH8OFpKgTHSApIKHoG5rvzSaPH+tVgqt0OjeTp6dn4HUse1GNUf5g6KfNmc5UFoRRDDgfbS5yXc0SSgzvcNAlqGd3PRacEyKAa/2xHQGYHHUP3Mm8k0VOl7S7A0gKJDChDevvduBHMfuAonlXbRH8M63DMGe8nHGCnsztCWHvaLiBczogdjurG/xPhZDVlUd98jwdfIclapRd0VP9lAhyaIbpT+bRsNsYRsubbnbkL8RRrKUI2ZO3Ci8suwf3a1JFIzFkoByWZYxgofDnQbQY0VSfbaLInu5z/i5pL15kQLAa514xuBCrkiqJk8WvKqgm2wUwg11AN/Uvy+v+sz5bXwyMIhtXxZ8k/zeQaKB3hbjmzKKdmaAw5IE2rsnmCNxBRApkQp5cthTiDQQXZhAcMKTzpZ9vjb9ZpucMLOFZyj7wlPF++O5TTYHg4QxtNXJQDBNWEMmLVsT+9ny9uQwjTAGwVALzpd7qDa7+d7woVzIgi7S53SRZyvXlirT1qnAb3y1aCcblR4ijjSJohxmpqcI0KsJwigR26QdOm2dEDsxWRR8Tse7+ncHBE/aat8gWllzxXT1baasqbN7VEEc/dwr8IaPThTyt8UT7Qua/qQTMdniQPzr7MTYnLdWxpb2Y69wGMenOgBpC/hZCbTlXIDx7j
 xyefU6OU
 uRWP/BniWIl5DSpGfOa5pJRMfAx0cDVs9rub74bSdbjgHymwECZ4YJLhpgj41Rh6Jlr8ALi1sEH1VblEevAB3LsO2MplFfLYiHNqbSIfT31Mv0K6AqeJsWJ7L6l9/FG46vLpcg9RQzqf4hBR4NbiOFg0bI9omXhI+tWIZKraU1E0zFsYKt+XNsOWgvJi3oD+ACvmg28eP9W4wbTtG+CbDFz3wAoQy4Qw3KSHSVH2aRA4+2J2gS9ukH7F1Dw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19 2025, Pasha Tatashin wrote:

> On Fri, Dec 19, 2025 at 4:19=E2=80=AFAM Mike Rapoport <rppt@kernel.org> w=
rote:
>>
>> On Tue, Dec 16, 2025 at 10:36:01AM -0500, Pasha Tatashin wrote:
>> > On Tue, Dec 16, 2025 at 10:19=E2=80=AFAM Mike Rapoport <rppt@kernel.or=
g> wrote:
>> > >
>> > > On Tue, Dec 16, 2025 at 10:05:27AM -0500, Pasha Tatashin wrote:
>> > > > > > +static struct page *__init kho_get_preserved_page(phys_addr_t=
 phys,
>> > > > > > +                                               unsigned int o=
rder)
>> > > > > > +{
>> > > > > > +     unsigned long pfn =3D PHYS_PFN(phys);
>> > > > > > +     int nid =3D early_pfn_to_nid(pfn);
>> > > > > > +
>> > > > > > +     for (int i =3D 0; i < (1 << order); i++)
>> > > > > > +             init_deferred_page(pfn + i, nid);
>> > > > >
>> > > > > This will skip pages below node->first_deferred_pfn, we need to =
use
>> > > > > __init_page_from_nid() here.
>> > > >
>> > > > Mike, but those struct pages should be initialized early anyway. If
>> > > > they are not yet initialized we have a problem, as they are going =
to
>> > > > be re-initialized later.
>> > >
>> > > Can say I understand your point. Which pages should be initialized e=
arlt?
>> >
>> > All pages below node->first_deferred_pfn.
>> >
>> > > And which pages will be reinitialized?
>> >
>> > kho_memory_init() is called after free_area_init() (which calls
>> > memmap_init_range to initialize low memory struct pages). So, if we
>> > use __init_page_from_nid() as suggested, we would be blindly running
>> > __init_single_page() again on those low-memory pages that
>> > memmap_init_range() already set up. This would cause double
>> > initialization and corruptions due to losing the order information.
>> >
>> > > > > > +
>> > > > > > +     return pfn_to_page(pfn);
>> > > > > > +}
>> > > > > > +
>> > > > > >  static void __init deserialize_bitmap(unsigned int order,
>> > > > > >                                     struct khoser_mem_bitmap_p=
tr *elm)
>> > > > > >  {
>> > > > > > @@ -449,7 +466,7 @@ static void __init deserialize_bitmap(unsi=
gned int order,
>> > > > > >               int sz =3D 1 << (order + PAGE_SHIFT);
>> > > > > >               phys_addr_t phys =3D
>> > > > > >                       elm->phys_start + (bit << (order + PAGE_=
SHIFT));
>> > > > > > -             struct page *page =3D phys_to_page(phys);
>> > > > > > +             struct page *page =3D kho_get_preserved_page(phy=
s, order);
>> > > > >
>> > > > > I think it's better to initialize deferred struct pages later in
>> > > > > kho_restore_page. deserialize_bitmap() runs before SMP and it al=
ready does
>> > > >
>> > > > The KHO memory should still be accessible early in boot, right?
>> > >
>> > > The memory is accessible. And we anyway should not use struct page f=
or
>> > > preserved memory before kho_restore_{folio,pages}.
>> >
>> > This makes sense, what happens if someone calls kho_restore_folio()
>> > before deferred pages are initialized?
>>
>> That's fine, because this memory is still memblock_reserve()ed and defer=
red
>> init skips reserved ranges.
>> There is a problem however with the calls to kho_restore_{pages,folio}()
>> after memblock is gone because we can't use early_pfn_to_nid() then.

I suppose we can select CONFIG_ARCH_KEEP_MEMBLOCK with
CONFIG_KEXEC_HANDOVER. But that comes with its own set of problems like
wasting memory, especially when there are a lot of scattered preserved
pages

I don't think this is a very good idea, just throwing it out there as an
option.

>
> I agree with the regarding memblock and early_pfn_to_nid(), but I
> don't think we need to rely on early_pfn_to_nid() during the restore
> phase.
>
>> I think we can start with Evangelos' approach that initializes struct pa=
ges
>> at deserialize time and then we'll see how to optimize it.
>
> Let's do the lazy tail initialization that I proposed to you in a
> chat: we initialize only the head struct page during
> deserialize_bitmap(). Since this happens while memblock is still
> active, we can safely use early_pfn_to_nid() to set the nid in the
> head page's flags, and also preserve order as we do today.
>
> Then, we can defer the initialization of all tail pages to
> kho_restore_folio(). At that stage, we no longer need memblock or
> early_pfn_to_nid(); we can simply inherit the nid from the head page
> using page_to_nid(head).

Does that assumption always hold? Does every contiguous chunk of memory
always have to be in the same node? For folios it would hold, but what
about kho_preserve_pages()?

>
> This approach seems to give us the best of both worlds: It avoids the
> memblock dependency during restoration. It keeps the serial work in
> deserialize_bitmap() to a minimum (O(1)O(1) per region). It allows the
> heavy lifting of tail page initialization to be done later in the boot
> process, potentially in parallel, as you suggested.

Here's another idea I have been thinking about, but never dug deep
enough to figure out if it actually works.

__init_page_from_nid() loops through all the zones for the node to find
the zone id for the page. We can flip it the other way round and loop
through all zones (on all nodes) to find out if the PFN spans that zone.
Once we find the zone, we can directly call __init_single_page() on it.
If a contiguous chunk of preserved memory lands in one zone, we can
batch the init to save some time.

Something like the below (completely untested):


	static void kho_init_page(struct page *page)
	{
		unsigned long pfn =3D page_to_pfn(page);
		struct zone *zone;
=09
		for_each_zone(zone) {
			if (zone_spans_pfn(zone, pfn))
				break;
		}
=09
		__init_single_page(page, pfn, zone_idx(zone), zone_to_nid(zone));
	}

It doesn't do the batching I mentioned, but I think it at least gets the
point across. And I think even this simple version would be a good first
step.

This lets us initialize the page from kho_restore_folio() without having
to rely of memblock being alive, and saves us from doing work during
early boot. We should only have a handful of zones and nodes in
practice, so I think it should perform fairly well too.

We would of course need to see how it performs in practice. If it works,
I think it would be cleaner and simpler than splitting the
initialization into two separate parts.

Evangelos, would you mind giving it a try to see if the idea works and
how well it performs?

--=20
Regards,
Pratyush Yadav

