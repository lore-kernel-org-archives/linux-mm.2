Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88076D185F3
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 13:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F1816B0088; Thu,  8 Jan 2026 08:30:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79F366B0089; Thu,  8 Jan 2026 08:30:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64C926B0092; Thu,  8 Jan 2026 08:30:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 50D566B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 08:30:44 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F2F0DC01A5
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 13:30:43 +0000 (UTC)
X-FDA: 84308881566.09.591707C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 01BD718000D
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 13:30:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mFyDgKcN;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767879042; a=rsa-sha256;
	cv=none;
	b=xdL0nexb+jk3mt4NbmdkfCHcq4OcQW55tzAWd6uJr7kVyjYfs1VEQsAC2bGPDQom60jI7l
	Q+zVOPZGaak2fPoLehvrYV8674RQD7ugia7NQmNqNhjhPzRKELMUtV3xWqTmPi+Q0ZAtYk
	TFrzq0oIxt9D0VLDhMfLTKCEAKjudFE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mFyDgKcN;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767879042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aS54TiLLCnx92UY79GztGwo3oIuCVTm+qoJhyO33ftA=;
	b=gyINuCuIyIC5Rx36OWDlj8bZo1Jl2bn1zwgdEPwzQMKN4xq2f2yJWujvUQADFupsZ3h3Kd
	BqkGoln+ffiK47v/drNtIIQE+1+HHUGriCWw2ulYUiYQ24Uf/RnPKvgGn5lyqqSd9pM4D3
	Sj5bJVJTDL4hr1vWBWVYcp5GbO7RmUM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E8F960133;
	Thu,  8 Jan 2026 13:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA56C116C6;
	Thu,  8 Jan 2026 13:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767879041;
	bh=vRUk+XqHdvozmufdhhIaefKBZmKIIV937W1GpquE0Gg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mFyDgKcN5yJXMTtMLhfm/Nqm2ush1z+2cvJyRvNNR/hLsLuF0Lvff6GzwiQXBPVnb
	 GMtX4ji9rGFN1LRfTnajht1i3eVEGSmj69plak3FtENocm5bh9n3giA1iJeAc8AykA
	 xxZkZi0N2zNE3/j8GzWjIqaNTqk+Atyz+Hb0oRBsjqtH+0JdrfFoqTKBLpCKWAWgAF
	 a4O2vFhe5GFtQjBQPIfaPjVnDhIcEgxHkb7qOib7SpJ/i9HeBn6jPY+Z82yvTALe4b
	 WfqAh6jCMPxXbVoAlPupZ2U8bHKVKoKelDDIjfchzpHK6kcznoqohB+8A8BgrzG7BL
	 zjzUH9n7TjqIg==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 7E85FF40068;
	Thu,  8 Jan 2026 08:30:38 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Thu, 08 Jan 2026 08:30:38 -0500
X-ME-Sender: <xms:frFfaSRVif06nMdRiz4KFPZI_aQ3K3I-IefcKid0aVrKPMCQuI-NNw>
    <xme:frFfaTK3ZimaT6zVwlCW2sgm4lY_qU17X6P2uBP9M3hrOlly8W2aGl9PJwFy0G5vb
    i5trDp2p6qQATtIxRuJr7gsURlICa6sw6o69Agbejqe3Y4boFGgo7Y>
X-ME-Received: <xmr:frFfaZPyG1RB9djcAbCbCeBhwN2SzNjS8IXYKBrjxxsLWJzrPOqjVqLNimSPdA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddutdeitdejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopeifihhllhihsehinh
    hfrhgruggvrggurdhorhhgpdhrtghpthhtohepmhhutghhuhhnrdhsohhngheslhhinhhu
    gidruggvvhdprhgtphhtthhopehoshgrlhhvrgguohhrsehsuhhsvgdruggvpdhrtghpth
    htoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehvsggrsghkrgesshhu
    shgvrdgtiidprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvg
    drtghomhdprhgtphhtthhopeiiihihsehnvhhiughirgdrtghomhdprhgtphhtthhopegs
    hhgvsehrvgguhhgrthdrtghomh
X-ME-Proxy: <xmx:frFfaVyixXgHd_9H9W4VAbjseEKGgabddGnqE47gOuP0zxIxTLM4AA>
    <xmx:frFfaXG0fXZwzoOa8P9t2XHzZOEGDt6g8Qw89Yy2Q9vgZUVqOFRevg>
    <xmx:frFfaRGENFgJrPnjS9W59vKz2_tB2_YDYBJsko9kRO8_XptEqycdjA>
    <xmx:frFfaYtL0QLr5WGK5GuzkKcCBZ_x5-5pcaXDrn6vv5Dd6_zRFNM3Kw>
    <xmx:frFfadtmhD6O7-VIj2avk77_ct4uJtnf7CyFVfN5Xr8QowIoRMDsLVQy>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Jan 2026 08:30:37 -0500 (EST)
Date: Thu, 8 Jan 2026 13:30:36 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Usama Arif <usamaarif642@gmail.com>, 
	Frank van der Linden <fvdl@google.com>
Subject: Re: [PATCHv2 02/14] mm/sparse: Check memmap alignment
Message-ID: <fwgrsslq74vk4dhkuh5hji3xnrql7nxuia6wdeexjltzb4feh3@nbshswn3egkb>
References: <3b758468-9985-49b8-948a-e5837decf52d@kernel.org>
 <CDAEC896-E3EB-4EAB-9F0F-70BC448B3B9A@linux.dev>
 <4f82b8ef-77de-422b-a9a5-691c4eca24a3@kernel.org>
 <glu3noshgeh7ktwwqofk7xcwkvhek2x3hrbdmyyo56gmctdx3t@adsfih557p7g>
 <2ace6fc2-6891-4d6c-98de-c027da03d516@kernel.org>
 <yup3hvfsn4tvfnv32mdf4yoabt4igb2lkvllfac72g3abdkovm@auqdaijzby7d>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yup3hvfsn4tvfnv32mdf4yoabt4igb2lkvllfac72g3abdkovm@auqdaijzby7d>
X-Rspam-User: 
X-Rspamd-Queue-Id: 01BD718000D
X-Rspamd-Server: rspam04
X-Stat-Signature: ze45d1xydwcrrg1btasjh878uwxiifbg
X-HE-Tag: 1767879041-542879
X-HE-Meta: U2FsdGVkX19k1iV6bH1fSA/PBf7U6Db4ORYTIKRtSB4bIxYKViuFS+c3neJRW5HZrju+ZsmurkP8VRkCyIttigzGDko4UTU8AIl3p4zS8TpsZ4S5iAWfbDVHgz0L/0iPG3U0JU5wKXFQHExfnXDmKK3JdszqxW5XcT68mcbARnpslKdcLAmCmoJc28IY1Xa+R6/OU6aU++iUCWbmv+OBw4PunZz/Nk0jL65sRBrGUxQpr2SkVPSd+3fxfdV3TlIclvVSXzZSMd9y3TrIcewiPnFgpsOT5K7CzZ4EeEaPf05SpAusqi4ObsQzb/wGN57cGhn2oibkTDZS8NeiJh3uysOJA52Q0jJiWZOwKN5ZXd1MEsLLg5nfrI5Y3bqMkHgi54L5QT515NqkAiSv8PNGEhPLl3O/x/irn8aO02L0saVVhyQvpBbiFP51mLW9HfQQjulW1ZrQZoy0ppkP9NwyYYkqWe3KYJ+ZD1OusB68NA5X4kMiKqAYwwY5q+eQbPseaqZNxgWYa1aMWQG6Lc2gyV8N1tk+RJoOlMwFHU2zEcqdLJIn6Jf3bNXY3vpNGpsIKCuP7n9ZN5W5dOcLj3ab1R8BLPNVCxaURAFIBvT2wUyWunFkMQ7/SlU+dGBjrP6mQOPpkNhDr7FU/wU/weIXTHENW1EUPsR0cUuFSodwKACgo4QAJXpiDBYIcQNo6pAb1rFMFpbFclGDYHlZ5TL8pRQCl2pp6n/CNBu7E9BrBym1Ws2z9jbqQoYmhJPZkuHpNJbXwKG8iM7q055NNC8AmUH2ak5RzoGrIpdm1et/F8ipm3eHt8olbWx+V9DKoFTntKkaqsP0zMEkNzA+DGXWAHx4J6qQ/PZeG7jEHBZBwg7SblFBdz4/WoI6BzAsD9pMbD54/pVEuAVASyZSSUSS9F5ntDdxoRhlJnBVws2x14sLeUjvCYrZm/h6XjAfsjUxUtT5TUo51sLIb9I6oyE
 wHpl/KL4
 dMGDASuKSYnXxFoeoz9PH5vSfd6ctfayTlbUp1qPdjGlF2W42djN4hfPhKJO4oEL82xJH8vIgIpx+jbasrGtNHojHUhm8YgF/RhH6KOgbWj523EiaKmLCJcB6bjoHFzQWYj0m6BuNy1IEL5WHT89NJj3nsh0q/SSka3ZrEqpssm/Ny8py/nFqVxmY66FqMSj9Hfl7EDPQfeQLUEXH8NitzmI460GluYgCqeaYAK2y3kkEUtZf+32/zw0iCbOYcQs2cPC6ksXMt9oiC57+YN7kZx8QDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 12:32:47PM +0000, Kiryl Shutsemau wrote:
> On Thu, Jan 08, 2026 at 12:08:35AM +0100, David Hildenbrand (Red Hat) wrote:
> > > > "Then we make page->compound_head point to the dynamically allocated memdesc
> > > > rather than the first page. Then we can transition to the above layout. "
> > > 
> > 
> > Sorry for the late reply, it's been a bit crazy over here.
> > 
> > > I am not sure I understand how it is going to work.
> > > 
> > 
> > I don't recall all the details that Willy shared over the last years while
> > working on folios, but I will try to answer as best as I can from the top of
> > my head. (there are plenty of resources on the list, on the web, in his
> > presentations etc.).
> > 
> > > 32-byte layout indicates that flags will stay in the statically
> > > allocated part, but most (all?) flags are in the head page and we would
> > > need a way to redirect from tail to head in the statically allocated
> > > pages.
> > 
> > When working with folios we will never go through the head page flags.
> > That's why Willy has incrementally converted most folio code that worked on
> > pages to work on folios.
> > 
> > For example, PageUptodate() does a
> > 
> > 	folio_test_uptodate(page_folio(page));
> > 
> > The flags in the 32-byte layout will be used by some non-folio things for
> > which we won't allocate memdescs (just yet) (e.g., free pages in the buddy
> > and other things that does not require a lot of metadata). Some of these
> > flags will be moved into the memdesc pointer in the future as the conversion
> > proceeeds.
> 
> Okay, makes sense.
> 
> > > > The "memdesc" could be a pointer to a "struct folio" that is allocated from
> > > > the slab.
> > > > 
> > > > So in the new memdesc world, all pages part of a folio will point at the
> > > > allocated "struct folio", not the head page where "struct folio" currently
> > > > overlays "struct page".
> > > > 
> > > > That would mean that the proposal in this patch set will have to be reverted
> > > > again.
> > > > 
> > > > 
> > > > At LPC, Willy said that he wants to have something out there in the first
> > > > half of 2026.
> > > 
> > > Okay, seems ambitious to me.
> > 
> > When the program was called "2025" I considered it very ambitious :) Now I
> > consider it ambitious. I think Willy already shared early versions of the
> > "struct slab" split and the "struct ptdesc" split recently on the list.
> > 
> > > 
> > > Last time I asked, we had no idea how much performance would additional
> > > indirection cost us. Do we have a clue?
> > 
> > I raised that in the past, and I think the answer I got was that
> > 
> > (a) We always had these indirection cost when going from tail page to
> >     head page / folio.
> > (b) We must convert the code to do as little page_folio() as possible.
> >     That's why we saw so much code conversion to stop working on pages
> >     and only work on folios.
> > 
> > There are certainly cases where we cannot currently avoid the indirection,
> > like when we traverse a page table and go
> > 
> > 	pfn -> page -> folio
> > 
> > and cannot simply go
> > 
> > 	pfn -> folio
> > 
> > On the bright side, we'll lose the head-page checks and can simply
> > dereference the pointer.
> > 
> > I don't know whether Willy has more information yet, but I would assume that
> > in most cases this will be similar to the performance summary in your cover
> > letter: "... has shown either no change or only a slight improvement within
> > the noise.", just that it will be "only a slight degradation within the
> > noise". :)
> > 
> > We'll learn I guess, in particular which other page -> folio conversions
> > cannot be optimized out by caching the folio.
> > 
> > 
> > For quite some time there will be a magical config option that will switch
> > between both layouts. I'd assume that things will get more complicated if we
> > suddenly have a "compound_head/folio" pointer and a "compound_info" pointer
> > at the same time.
> > 
> > But it's really Willy who has the concept in mind as he is very likely right
> > now busy writing some of that code.
> > 
> > I'm just the messenger.
> > 
> > :)
> > 
> > [I would hope that Willy could share his thoughts]
> 
> If you or Willy think that this patch will impede memdesc progress, I am
> okay not pushing this patchset upstream.

Or other option is to get this patchset upstream (I need to fix/test few
things still) and revert it later when (if?) memdesc lands.

What do you think?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

