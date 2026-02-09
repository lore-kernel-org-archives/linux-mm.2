Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F854E81BA6
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 11:52:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB6946B0005; Mon,  9 Feb 2026 06:52:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A98276B0088; Mon,  9 Feb 2026 06:52:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C51E6B0089; Mon,  9 Feb 2026 06:52:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 89E2C6B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 06:52:24 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 336011607BE
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 11:52:24 +0000 (UTC)
X-FDA: 84424755408.05.11838C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4A0104000B
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 11:52:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hH1QHvfK;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770637942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mCEKzjWWq+XHPSyDS9Xb2PDUFB7LBG5MTEVIY1i0mTw=;
	b=hvqjTu3QFfS0UTkUpqOpeMdKHze+yvFgvWTeGUJwU6PgWuMUqABrCmcxlUysZ7ixQ5NeNF
	AIEsgxX24lVJLzrgoqpmQbODOTFdHoZuyPVRk4O3gLrkfnUrwQQpwexwcooJj36m9AXWg8
	KxVIeq3OzpR5kNhAtwq9+hC0DYwbNnA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hH1QHvfK;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770637942; a=rsa-sha256;
	cv=none;
	b=oZjjuyqjSwpmjYZxbYPoKDMZY6+dBDeHNWq85rCh6cdLXk73ILUE9fSDtS9eg/PhNx7+n/
	Mpdp9d86osemSPYSBKo1/ycx97mTGnbb6uOua0iD3BGgbf1NNWah+8d0w0JwP5x8mIbstI
	93ufyyAJ6k2PQX45sLn0hBFvsQ/7l4o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F416600B0;
	Mon,  9 Feb 2026 11:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9E3C16AAE;
	Mon,  9 Feb 2026 11:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770637941;
	bh=/oVfWEPDEAt5G8rJ12d4rW+JXmSiJVKmDZMLxp+j8rQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hH1QHvfKc7CEJbSL0jt1YJJAqkMs759E290lV0qaNYFiNewfF2Ti/nUXuSSLl6rbc
	 wxaeDRbEkGrHOS6hoDtZ9lGQZtbRiCKPU2RrNffy06KwcfMMsZsXJ67vfP2LPwyf/H
	 uqyaL6pGSPycCvB41OiJtW95NihkBpCG7/k57aJJQ2Veom3VNwRF0sNgT7HJFF7ojp
	 u407lKJtbEoLyPWvbYZ6ECZJqjDKWWMuyESJo9WIs4TteL2FqbsNtAI0g86D5mhTFn
	 vXPBSmYoWrii+48+QrwZFcDJSCq5sQbs92l08YQzuXpg9wQ6TQSoVGWvv+1jF7OVGv
	 GyXhG+FdGllNQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 7F447F40068;
	Mon,  9 Feb 2026 06:52:19 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 09 Feb 2026 06:52:19 -0500
X-ME-Sender: <xms:c8qJaRnGgHcwQlUzKxM0pi1M6-sooBlwZEoLpFUFMGR7HRbHFqyO3Q>
    <xme:c8qJaQiJeXcg7jUEq21SU_9vYrWiTR0pldGbxPvjkRdWUvaC-puVBUk87Zn_-b_jp
    pPi1wIM1DBsogn1-UA00mdLWYjp3bRgG40OSLBt7rdrxECqYpa-K0w>
X-ME-Received: <xmr:c8qJaSuWjkk_xgUOyTKjFMNbnGwBGVYvtdWmNUhZy39Lahey-cfTbWuxswkiog>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduleeijeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepheegpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinh
    hugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepmhhutghhuhhnrdhsohhn
    gheslhhinhhugidruggvvhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:c8qJafBxveFtzYJ6sUMVxdezrYUNbFteSL281M5auAzdFoY-ZftXtw>
    <xmx:c8qJaVVAfx-CKI9XWQgj2X8tsJxQcG_EWguwGOVW9HLLVWHHcfZnVg>
    <xmx:c8qJadJJiU55uXizmOjCpiQQscs8mVm0de_3HA4JnGZLPHwuHr7zOA>
    <xmx:c8qJaeVyZ1n4cPaoHrIWYehWghRX-6E3bvjJAlBHqxqmt7qbPfbzgw>
    <xmx:c8qJaWSArh7v-pa87OwkWLqvR1MBp2DxJl5d6Rv7stWO7ti6O7oPdFzq>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Feb 2026 06:52:16 -0500 (EST)
Date: Mon, 9 Feb 2026 11:52:11 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>, 
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
Subject: Re: [PATCHv6 08/17] mm: Make page_zonenum() use head page
Message-ID: <aYnJCnE5vooLROnu@thinkstation>
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-9-kas@kernel.org>
 <e5831f0b-88c5-4a20-82b3-6e5952388132@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5831f0b-88c5-4a20-82b3-6e5952388132@kernel.org>
X-Rspamd-Server: rspam11
X-Stat-Signature: su1qeyaq8nurawhnc5c98bkog8mwhckw
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A0104000B
X-HE-Tag: 1770637942-451049
X-HE-Meta: U2FsdGVkX1/IeVvpcr8+l/G5uX62CwspPvQo5BUUiQHiVsb0NqggD37EdSXSAjSnSWPrXpf9S4S39FkQaxiM4BpNx/ZjS16XijWOHcH8TFLyAuRC/ZC852GsE4NGT2pdXJG7vUGElU/1I240pLVOWfpX/uQeoOZz2j9myH82LckaDy4Kp02BimRxuUNXfmuvTW9frj05T9jC2FfbZUes31Hc9P/uMdW2QR2yfJ4Hr6iY4rkbucgSflSoGfEsawJ0V4wRloKobxbsVOBJG3MhZ+z533UZwinwZtiJTuAVM/OVk7DwGzmiIkih7pTuWBfhylME0g8h0sB5owkJR8VqSpVD83guEI1vEYJ7VvQ75JeMQH4sgTsXP8OoFZXeMVvS8Y5/gj3IuoSgw6zu427R/6DGQcaWhABgjVBEX6lhyVWwn75XigkHl1RtPAqlFGxHkJTz0zaQiB5Fgv8yXhRnSjhvy3egHTzsDCjAVBk7ZeP/B77AABz3jZZeIdTgBazS3m0uCYki44jq/dE7sfh7kEHYQVPu6G+SdTajfrfr7r7+MbysaOcOo3o8rjl2tMUr2dzghhFBhWn6zEKXoqc1RMAu8FUaMvCiNrgzSuSosyCnxj5KYz2gsHHn/uBvd9+E90OdIiJkMMtc/faKp5JId8BHleDeY384AjWvasAFV0AG97a3y+wMKqHt1IUD2r9iTKKXeRqdDdUTDbOSczp3rXuQjTdwGmItKnEZHB03aIx2+wBCaszdn1hAKOyXEz9GdLmlgYzokZFL+qRp9cSjVQGp4eFgGkNKVC2d5sOgpL+B+wI2pZ8sOTFLSYNivL5Rvo6uyM/KAL9r3LQIk0Llq2lwRBIynce7Zh2p6zOCU5/6vTwsSVJihxFdOiGBtjlWfEIhiPO4DMm6fw0Kcfnwq3uZaM/bG1uy8E2b3lulcDdOqs3uVqS3aiSDyhZ/FUUUf6miLYF7Nvn9Q12mvpl
 aWO7hy8b
 9/hF0wEjCna7Vf/elUaiB0xQBtAOtNg64RpyBpwbGm/3KngqV3X13tj5Q7d9tG9NKiPn+N0UqxBMfA/fQH3jVVebiQJkFHtWqQgmWiS38YFUlmmdDZ5Zwp8eQEkJibggBe5dmNvOPtYRYUqjD+rrBWbs/1N3Z8nE7mnd+EizIvHkFaHqJOv+SsELtqNyBZxQf2TzlIHpG6c/J4SQxFPMJhcX6jbJJEaZ2ccj4Mbwt4nab3UdNbbjgqBNiK7My2FhgQ1o6BGvJDXoZqfCghNjtVb954CQB1Kcn37GtiPM21CrQxdyLjQ7LfDQqIih5q9VOM2TwDUrhd+Vtm8AnDQLid4ix4v8AsI+WDXOlKAiOaSJzfMA2peWCKoWSvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 02:10:40PM +0100, David Hildenbrand (Arm) wrote:
> On 2/2/26 16:56, Kiryl Shutsemau wrote:
> > With the upcoming changes to HVO, a single page of tail struct pages
> > will be shared across all huge pages of the same order on a node. Since
> > huge pages on the same node may belong to different zones, the zone
> > information stored in shared tail page flags would be incorrect.
> > 
> > Always fetch zone information from the head page, which has unique and
> > correct zone flags for each compound page.
> > 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > Acked-by: Zi Yan <ziy@nvidia.com>
> > ---
> >   include/linux/mmzone.h | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index be8ce40b5638..192143b5cdc0 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -1219,6 +1219,7 @@ static inline enum zone_type memdesc_zonenum(memdesc_flags_t flags)
> >   static inline enum zone_type page_zonenum(const struct page *page)
> >   {
> > +	page = compound_head(page);
> >   	return memdesc_zonenum(page->flags);
> 
> We end up calling page_zonenum() without holding a reference.
> 
> Given that _compound_head() does a READ_ONCE(), this should work even if we
> see concurrent page freeing etc.
> 
> However, this change implies that we now perform a compound page lookup for
> every PageHighMem() [meh], page_zone() [quite some users in the buddy,
> including for pageblock access and page freeing].
> 
> That's a nasty compromise for making HVO better? :)
> 
> We should likely limit that special casing to kernels that really rquire it
> (HVO).

I will add compound_info_has_mask() check.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

