Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6AEFE7545C
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 14:13:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 271C76B00BE; Wed, 24 Dec 2025 09:13:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21FA16B00C0; Wed, 24 Dec 2025 09:13:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 102016B00C1; Wed, 24 Dec 2025 09:13:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F2E546B00BE
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 09:13:33 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ADB8E13A085
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 14:13:33 +0000 (UTC)
X-FDA: 84254557506.06.FA950B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id A543116000C
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 14:13:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FHYGOWuZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766585611; a=rsa-sha256;
	cv=none;
	b=ZaJuiMmq1sn7k6ocrMguZdEJse1Cx5rIf+WA5cI1PKWCYGWsOLMNN6NxKyaIcyjxsTssHu
	cTmO7T4M0DVTndyPINXsA0P06Wo0I8WvNXqMaOJnzSmoeKu1TRxLkVGEbblF3wT36yrT9t
	XuTQ4N8+4b/njN0CJcgaIH58dWgf7m0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FHYGOWuZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766585611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kzkA9M7rnT/5r2kESPfREb4wj7Ej8XVfsji/ba3gWW0=;
	b=J1/R4Jff/Pj0IOyBk1zunMVWrKGSvlt+w/GnvHZIgKXl1aUaSQDQ79CVauqvNFZNxvA96L
	rXWMdOwyajUHA6PzYD1yi9Zs7oLcF+a8D3MiiUTqUCfvOGhtldghowYr5ANPtqlxv6qXQ6
	x1k2bsGk1HSnBVYTHXW+gZ/Ho9dmwh0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3037860010;
	Wed, 24 Dec 2025 14:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4B7C4CEFB;
	Wed, 24 Dec 2025 14:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766585610;
	bh=x8pJJIM/R06HelItOz0mnR+O24PLB75z92hRRpCFFeo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FHYGOWuZptBIcppYTlXBn4sW3MVXb73WxXQBc1w0Uz2XM1bPDLLjN9Jus9pa/qafZ
	 O7IYlKUgSP6XtbxOkd+30wV073htRop2HRncbeI29eS6/kKtddadTdk6rYpmxTa8M9
	 FK11xawVfOsKteVVw8OR/8sQad8LmfylBKi9a8ppmr9LJ/9c87eUsG31m53U5FCk2z
	 zn6KzNGK5U8vvEhNl8hR6PzwBlrmEqfgD1myx8QukTR6kMyB0U9j2qwgB0lK0FVEiQ
	 OH37k7/7YV1F+DMbXreI2CHByOpPInE6s/6qXsD4PCSYP/exWabMeyBcMr17U1kmrB
	 h+el++vo8GjGA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 834B7F40068;
	Wed, 24 Dec 2025 09:13:29 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 24 Dec 2025 09:13:29 -0500
X-ME-Sender: <xms:CfVLac-XX2AxodhMm2mUM5fRSkfYO3sjew5HQLb5H_m7r92kjH_Glw>
    <xme:CfVLaQG8Kn4K6xiF50TYZCxH_2Uz-uASo_yTsKOi9vkkLfCCYAshPunSctm6b8LvI
    MgLIUuefwwwIiID7se007ajPfGyu0zELphyntpfFGm-G4OHGgegUqA>
X-ME-Received: <xmr:CfVLabb4t3iCERwBSA2ye8Xqd2k23DDo9Y_G32SgQqovU6hLGfVGUOwoj8tzJg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeivdeludcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtugfgjgestheksfdttddtjeenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepvddufeetkedvheektdefhfefjeeujeejtdejuedufefhveekkeeffeetvedvffek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehmuhgthhhunhdrsh
    honhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggr
    ugdrohhrghdprhgtphhtthhopehoshgrlhhvrgguohhrsehsuhhsvgdruggvpdhrtghpth
    htoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehvsggrsghkrgesshhu
    shgvrdgtiidprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvg
    drtghomhdprhgtphhtthhopeiiihihsehnvhhiughirgdrtghomhdprhgtphhtthhopegs
    hhgvsehrvgguhhgrthdrtghomh
X-ME-Proxy: <xmx:CfVLaUOx-z6rz2cOkZTXqlMD7SVzr_JasznpUOQR_W4nbGIocrSoPw>
    <xmx:CfVLacyW2XttqkD_f7r3SSyY329K9l__Gd6JRd2zpul-LSdyEFzl1A>
    <xmx:CfVLadCmlcOXe_qvSVLcH65ZUWmmT7zCnJ_DPdjzrVIXPYfb5aO7Og>
    <xmx:CfVLad6weKrosgU6y7QTtpOYp-LbHLKKriDGpJvsEcGMVH2be6LVnA>
    <xmx:CfVLaTIdV2jFWK8oq9ccPbQ88T8QPugBXrDk1urbA8innEyGNP2Nr0Z3>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 24 Dec 2025 09:13:28 -0500 (EST)
Date: Wed, 24 Dec 2025 14:13:27 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Oscar Salvador <osalvador@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Usama Arif <usamaarif642@gmail.com>, 
	Frank van der Linden <fvdl@google.com>
Subject: Re: [PATCHv2 02/14] mm/sparse: Check memmap alignment
Message-ID: <glu3noshgeh7ktwwqofk7xcwkvhek2x3hrbdmyyo56gmctdx3t@adsfih557p7g>
References: <3b758468-9985-49b8-948a-e5837decf52d@kernel.org>
 <CDAEC896-E3EB-4EAB-9F0F-70BC448B3B9A@linux.dev>
 <4f82b8ef-77de-422b-a9a5-691c4eca24a3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4f82b8ef-77de-422b-a9a5-691c4eca24a3@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: A543116000C
X-Rspamd-Server: rspam10
X-Stat-Signature: 85fsddpgw5mxc6krik9xou4mjskucpdr
X-HE-Tag: 1766585611-18164
X-HE-Meta: U2FsdGVkX1/JbD/Szf5kMUlipwWJWsYcBaX70sraa/hyWKfOZbuGwbGHrX3YAc0m/ntifo+HIeSnX2GYxi3DYBTQmWrA/l/OuJQHzPsnnXyIbDgvm1KQgewwjEcmhKkmxDy0DhoBm3OWSgMcz1JEKPgHu981xPjNVkzmK3LqkgLwMdFgPTXeEwMBE0xdwZ3XyKr22MJm8JUpaIT1JKyUZL+jvFIAX0i2Oot7Vpxr8/kTJoLT4yOnXGhhyHEFRHv/Mqo+qHStOumBuPEVkrJ42kGMERiy1BHwTE4ha0ZIs4EHB6vYCBjXdZr5Ho20NegFXn71JaEwKpfi0afK7VOfU8Oq+QmwyoT0JfIwbiqwSpvNZBrlbB2WR7EFeEtjjbX7WYNkxS+WYajSRLqhGUwdY0Qv3Dc3JMnVEAbGnbQaEDf3MfOsjPlKwqsOaKEstk54bpN+oG00PXHwvlTtxa6tKyLwoh764sEzW6m6t6trmg1nyizy3iyjMByqGpE5aiFJNEjbEIZl1LLj3c6IBBq4Axm9oTu6L1n2MeORXh/hIHH9KqR8yqZB20cNl60S7lG3Gs6329vPQ38xAEhjv5hpu+OkRIbY5O8rJZhdzUQp3xMigxRNifY71PwHgnfw7DpRa5ZoUMSf+CMS7fEeIFm/sS25ePVKRuFjs546AhNKtGzFbKBzzwMoNLznJcTv9NWJzYtPR+vUZumIQujQOqr0rNv9Utsi2IzQcv3Qmei3rkYI1CPFdtHBMjBxYzAYeslq8BUn8RplFqL+FKs3wrMRm9sjFXnLz/72J2523mlkXaisyiEGYzOFFznNVq9lT5djrazZXDlzyfES8pHEfD02YJ0aLYxAa+It6dCXODtJt3JCB9quq6Og1m9F+Ob3k2yyLTMxqXu8Pper0KWjyXDETzXKTekrn34j4EVq7qG08vhWfHMoWA/iDrDvng07Z1ueDrSr+RkJFxfPE3v+smF
 ZXbOZSc5
 wwrCZKmIzbOonlDWr3eBUPVfvCC42V9Lv3Z3ECtLLdibdA/ALJ1Fykn83/mbSgxbWGESTXLF0xFiJIC9b9/ntgrz4AhYY+r/ET46xA6ZlK8ZcRYI9LsZpi/+8A4c6I1yGj0MEAihWS5CPacolANXakLc2Y4SKV9Bb381c5TESFyCnA22YZNvPfoaU/Mk005B/2yUwdyBzVeXg8pofW8lTINWUviTDcClM5l7kgScZwe6A+nmYu08vsWVpy2B+BQ2Xjld+yOuC7Jeh93qWznfxeDeqjdUvuSJOdI5w4yFNGMI067HcDXci+Ukqea+vKE45v/WaDGSe4lShskI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 23, 2025 at 10:38:26AM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/22/25 15:55, Muchun Song wrote:
> > 
> > 
> > > On Dec 22, 2025, at 22:18, David Hildenbrand (Red Hat) <david@kernel.org> wrote:
> > > 
> > > ﻿On 12/22/25 15:02, Kiryl Shutsemau wrote:
> > > > > On Mon, Dec 22, 2025 at 04:34:40PM +0800, Muchun Song wrote:
> > > > > 
> > > > > 
> > > > > On 2025/12/18 23:09, Kiryl Shutsemau wrote:
> > > > > > The upcoming changes in compound_head() require memmap to be naturally
> > > > > > aligned to the maximum folio size.
> > > > > > 
> > > > > > Add a warning if it is not.
> > > > > > 
> > > > > > A warning is sufficient as MAX_FOLIO_ORDER is very rarely used, so the
> > > > > > kernel is still likely to be functional if this strict check fails.
> > > > > 
> > > > > Different architectures default to 2 MB alignment (mainly to
> > > > > enable huge mappings), which only accommodates folios up to
> > > > > 128 MB. Yet 1 GB huge pages are still fairly common, so
> > > > > validating 16 GB (MAX_FOLIO_SIZE) alignment seems likely to
> > > > > miss the most frequent case.
> > > > I don't follow. 16 GB check is more strict that anything smaller.
> > > > How can it miss the most frequent case?
> > > > > I’m concerned that this might plant a hidden time bomb: it
> > > > > could detonate at any moment in later code, silently triggering
> > > > > memory corruption or similar failures. Therefore, I don’t
> > > > > think a WARNING is a good choice.
> > > > We can upgrade it BUG_ON(), but I want to understand your logic here
> > > > first.
> > > 
> > > Definitely no BUG_ON(). I would assume this is something we would find early during testing, so even a VM_WARN_ON_ONCE() should be good enough?
> > > 
> > > This smells like a possible problem, though, as soon as some architecture wants to increase the folio size. What would be the expected step to ensure the alignment is done properly?
> > > 
> > > But OTOH, as I raised Willy's work will make all of that here obsolete either way, so maybe not worth worrying about that case too much,
> > 
> > Hi David,
> > 
> 
> Hi! :)
> 
> > I hope you're doing well. I must admit I have limited knowledge of Willy's work, and I was wondering if you might be kind enough to share any publicly available links where I could learn more about the future direction of this project. I would be truly grateful for your guidance.
> > Thank you very much in advance.
> 
> There is some information to be had at [1], but more at [2]. Take a look at
> [2] in "After those projects are complete - Then we can shrink struct page
> to 32 bytes:"
> 
> In essence, all pages (belonging to a memdesc) will have a "memdesc" pointer
> (that replaces the compound_head pointer).
> 
> "Then we make page->compound_head point to the dynamically allocated memdesc
> rather than the first page. Then we can transition to the above layout. "

I am not sure I understand how it is going to work.

32-byte layout indicates that flags will stay in the statically
allocated part, but most (all?) flags are in the head page and we would
need a way to redirect from tail to head in the statically allocated
pages.

> The "memdesc" could be a pointer to a "struct folio" that is allocated from
> the slab.
> 
> So in the new memdesc world, all pages part of a folio will point at the
> allocated "struct folio", not the head page where "struct folio" currently
> overlays "struct page".
> 
> That would mean that the proposal in this patch set will have to be reverted
> again.
> 
> 
> At LPC, Willy said that he wants to have something out there in the first
> half of 2026.

Okay, seems ambitious to me.

Last time I asked, we had no idea how much performance would additional
indirection cost us. Do we have a clue?

I like memdesc idea, but indirection cost always bothered me.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

