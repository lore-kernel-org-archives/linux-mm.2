Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10E2ED374A3
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 20:54:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FDD06B02EC; Fri,  5 Dec 2025 15:54:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5456B02ED; Fri,  5 Dec 2025 15:54:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 312656B02EE; Fri,  5 Dec 2025 15:54:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1CB886B02EC
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 15:54:56 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B213013A88C
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 20:54:55 +0000 (UTC)
X-FDA: 84186621750.11.3853652
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id C677C4000A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 20:54:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="de/emt0Z";
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764968093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LcuQ142UKHYep3O/KdwjgXZZU86t6qftajj2L4HL1w0=;
	b=FeVAATpMtoYMaddpnWo0GnY5DZD63PtdCr/tafx8HqMzRVYE1eaVYSzQIvuEzLi6LbowZ2
	acB/V0jzGEO0wnna0yB8HSBzusDgj8bJxH/LQnc1qKOhtDeDXTRwLdYbkaeyKYp9LuwVkb
	eGePVFn6YYzWw++QNugHnEJOIoeHc80=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764968093; a=rsa-sha256;
	cv=none;
	b=NpVpIjVSnv9fS9MTTOPCP85MPfNd9JP5w83E+LN3Vix8D94M90PFk6Y8Q+VLE2nfLoUUzA
	e4Ow0K7aO4JkbPi3kRqhkk9eobD/582wM3NSbi6HDadzXNHwKqb8mEW+2AD0OO1kekdeXu
	rjLfkm0fHGBnApCGRWx6++uKfMSu3ro=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="de/emt0Z";
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 487E460156;
	Fri,  5 Dec 2025 20:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1EEC4AF0B;
	Fri,  5 Dec 2025 20:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764968093;
	bh=3HzhDUItFLhL4WKaFFSsqNbgeDl5tzAw/wnROhrEui0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=de/emt0ZFid7L69Y9kFMqAs7Az++aUY7Ekkjav4AYdlwdLmmSZBBoS5hXt6vg8Nla
	 TF2To9ZIxuEW5Cv4Mmb2aTPcybmCpwn+/E3jLSQwHW9NBOvL/pSa/YOoAbcyVpT8Dx
	 BJ1yPIVNVDNz0Vw13b0U2wtMiZcarghwRDdjMdj2aRyEHlVdBqf1SMdxpGq8SQASM2
	 e14W9L5FyULlKpkzuVexhmaLa+mLLEK6rMvaPlaGH2e+axWwueCNqdl88AgQ86SPBp
	 KitddyS3lzkrRIRZ9h1uXITXSOkBDC47OE6s0uRDoWrMJtFR94fyL/oEhB22mp7d+c
	 K0eaeuF/VWqDg==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 7CBB8F4006C;
	Fri,  5 Dec 2025 15:54:51 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 05 Dec 2025 15:54:51 -0500
X-ME-Sender: <xms:m0YzaVchA3Iv6PT9einV5JgeMvJFQkERSjBFRQf5zEaZx56ofcBnpA>
    <xme:m0YzaaDBnS04iE9rW6PpcaQ6BtiZwf49jW42Kzqh4r9iQiNglyuaU-Dof4ewUhX3Z
    gu5rWQLHVQ6JdxKskSvvZlKpN9qh24DdA8ysuK8wP3bA5hFgERWBGk>
X-ME-Received: <xmr:m0YzaXfHLkX_GwngSOlc0dWDhpSUgzO5jYFfM4HPIFL8rlvZrOL0ZEJ0C2c8fg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdelfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnh
    epheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilh
    hlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheehqddv
    keeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrg
    hmvgdpnhgspghrtghpthhtohepfeeipdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugi
    dqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepmhhutghhuhhnrdhsohhnghes
    lhhinhhugidruggvvhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorh
    hgpdhrtghpthhtohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehr
    phhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtg
    iipdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhm
    pdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:m0YzaRyj1aerwRjmovq_zank8kZ7VzJ2FcCe4pu3rFFJk6aXqxg2bg>
    <xmx:m0YzaV8eAiz0r_PX5ZYuLJDFKXZcC0Iyr4Bq83RCNHOBX-1KwE_qKg>
    <xmx:m0Yzabmwsmi-t1T6tsSZqchCNUjQOGhuoG8KXXGXNV64a1kLEhQDRw>
    <xmx:m0YzaXqxJ4KTv2HXnmRRbNaRfV89gb_Cx7WrkWhjcOXO9y-N9CCrLA>
    <xmx:m0YzaX91OxC0IWaeyu0xi2Z-YNsQj6glNVQ18rJVhCHDioQ7_G-OA4O0>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Dec 2025 15:54:50 -0500 (EST)
Date: Fri, 5 Dec 2025 20:54:49 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	Usama Arif <usamaarif642@gmail.com>, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 00/11] mm/hugetlb: Eliminate fake head pages from vmemmap
 optimization
Message-ID: <ysvhofzg5mdtvxfujdsmffkuqna72pr52ehrpglmlhxnvwstas@xurgptkgtnbe>
References: <20251205194351.1646318-1-kas@kernel.org>
 <e1c50f7e-cec4-4676-b5d6-f6446cd64ba5@kernel.org>
 <bdie34dgpltxd5ayvjvqkusx4thdrrebgllvwp333psfuu4vgj@bkfxg2c5sfr2>
 <01e5d0b3-dbf8-4f77-b38a-f48c46f7c31e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01e5d0b3-dbf8-4f77-b38a-f48c46f7c31e@kernel.org>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C677C4000A
X-Stat-Signature: qmao6n5zmq4835nhcj3mgy1bogws4wad
X-Rspam-User: 
X-HE-Tag: 1764968093-86802
X-HE-Meta: U2FsdGVkX1+q2VsuJOpAIowufRLMFBBCb88CD97dWwlUIvutbwxi/RifgEAaNQbb9cZiwxwaoJ8rXR/GfQPzzu++vfnXfZm//FhriYcXu8QLoqapI28n6TRxyuQGaYOFPpUWK09/N7y+ZrEZvQuhPYSmMQjLw3TG6/m37+75fP/c6gTYAWcyM3zd9FsuA7SFf+X7j2Px/NqYGFjumYsQYAIx/llUbg/NxedZkOouQQ9p3L4MH+LTvRxGPcoCYPvXzdUIpMw+wS2ZpcKTsEym0bmJa6ez/Ft22QirFCFTLhZxypSiF3DdQkohIPX7v59wQgb7pr/auSYg4J6CGbOslB+B5yw7efA1mTcryqRbaPxoJpUKzRf0pfXrk0WINNiS1uDn63CVhJJ/SLRXCBYZXLdsAmM119ZNxeGLoZKY9D+0otgOdL2P6kMq0pUux7ByZrLf62Sj3YbitYcj+QgNvsKTpi2Vx6ph8pciq5CyP7vqHT9YgWifrkveg3hBxvzG3IqarD/6WjCabrcnJi5o/sIZeqt5Nf6mqKpTH9Qy7z+5KqF7mQ1GEihfsvads9P8xQM3zTNQiaW9E+9j4gUWI0SVwz/n5YRn7S6Y+6Gb0M3nni9Bb6wArs1VU64FEUhxbYoEPI1Z1dGP8d22vxnjHRI/9Zw5kqAoeq/lNZ87K/K7cr13hv8mSBROzAgZu7Zr7/f21/UFpZKmZLXkUXmWF5xwMKxuv6zvmPTMwSRGxt9h0m2WGKTty66exKuRFtT9/L8hV24Yln2M0AlFPJ3v82c8Ld1jp87UZoTHHpJHsnmYUJ1BHoEbV8Eu3OXqL5cPPbQMQBDoSKsqh6Nidhge04Oj++kpI9K/Q0I25Xrc+uHpU+KK4uqZRm9T6Xmu75MQycAL5oyFanKGEQCsGHVejRpaDxdsEgRBAdQhn+nnFL541d7jyROHe4xcz0627CCkLrLZQjouOoHN3C9I0ys
 TCudscS+
 uZZ54D6mgdl/qqrh034DMhBjZW7XSYW2CXLboy2d3BvOsC+T7XN9xa+H5z/Qks3a/8FE/NyYxu/FZUKmGLf0z4ZVKntLvvHV6YBJjdNt6xyQxuY/jsGGu++hoc7uWHTM44R1cMoWbmIReR69ablMvV/7gGLPztE4/rOFeeD9rravv43zipXJhd2N48WbZniZSPSx6b3ygPYz/Xe5NPkhTnop4+9RZR0GOONL6tQdmOEnNc5ZZbINNUYk8938ODxFQRxQtjrjR82brXngalkyrnpxajw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 05, 2025 at 09:44:30PM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/5/25 21:33, Kiryl Shutsemau wrote:
> > On Fri, Dec 05, 2025 at 09:16:08PM +0100, David Hildenbrand (Red Hat) wrote:
> > > On 12/5/25 20:43, Kiryl Shutsemau wrote:
> > > > This series removes "fake head pages" from the HugeTLB vmemmap
> > > > optimization (HVO) by changing how tail pages encode their relationship
> > > > to the head page.
> > > > 
> > > > It simplifies compound_head() and page_ref_add_unless(). Both are in the
> > > > hot path.
> > > > 
> > > > Background
> > > > ==========
> > > > 
> > > > HVO reduces memory overhead by freeing vmemmap pages for HugeTLB pages
> > > > and remapping the freed virtual addresses to a single physical page.
> > > > Previously, all tail page vmemmap entries were remapped to the first
> > > > vmemmap page (containing the head struct page), creating "fake heads" -
> > > > tail pages that appear to have PG_head set when accessed through the
> > > > deduplicated vmemmap.
> > > > 
> > > > This required special handling in compound_head() to detect and work
> > > > around fake heads, adding complexity and overhead to a very hot path.
> > > > 
> > > > New Approach
> > > > ============
> > > > 
> > > > For architectures/configs where sizeof(struct page) is a power of 2 (the
> > > > common case), this series changes how position of the head page is encoded
> > > > in the tail pages.
> > > > 
> > > > Instead of storing a pointer to the head page, the ->compound_info
> > > > (renamed from ->compound_head) now stores a mask.
> > > 
> > > (we're in the merge window)
> > > 
> > > That doesn't seem to be suitable for the memdesc plans, where we want all
> > > tail pages do directly point at the allocated memdesc (e.g., struct folio),
> > > no?
> > 
> > Sure. My understanding is that it is going to eliminate a need in
> > compound_head() completely. I don't see the conflict so far.
> 
> Right. All compound_head pointers will point at the allocated memdesc.
> 
> Would we still have to detect fake head pages though (at least for some
> transition period)?

If we need to detect if the memdesc is tail it should be as trivial as
comparing the given memdesc to the memdesc - 1. If they match, you are
looking at the tail.

But I don't think we wound need it.

The memdesc itself doesn't hold anything you want to touch if don't hold
reference to the folio. You wound need dereference memdesc and after it
you don't care if the memdesc it tail.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

