Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACDB1C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 11:28:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2DD36B014E; Thu, 22 Jan 2026 06:28:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD7956B014F; Thu, 22 Jan 2026 06:28:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A04DF6B0150; Thu, 22 Jan 2026 06:28:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8F2956B014E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:28:20 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 44C28D262F
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:28:20 +0000 (UTC)
X-FDA: 84359376360.30.614AFA7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3701D140009
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:28:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="MqJz/s0v";
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769081298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ano9sZ482uhTIIyfGB4c1DwRRTTdGX/WJXZaeGmfIuw=;
	b=UTSrYWsWZqqXQ0PAXN+XfqCvpgYlMPn2korR/G12yc9zZG5OAIe4lsSWQlvSv6Y6M8e+NY
	8Mb8dlLcdO51EwL3W4B4NQiLJ6R9/KZOrOKtSJ6omLdaOmnOVV37N40/ag+O35z6bjOlHO
	vFdj7Mg7pDivttoak27iO+003ljnbOE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769081298; a=rsa-sha256;
	cv=none;
	b=spedEpwELCVxANILvbh/uTN8hTXCqFcA5si5T8ztT9RZ0nSA5ETNe7mwZ8WARN6bbVhCkM
	nY+YKvvhOLEdUtDr78W+tAGaBOlAL5WRcIpWyZd+xwg6aU7hkE4kgdWqUkpAkaIMHXhO9l
	KayYq3ae+fbUh8E9QtrARTQOvUxAiQg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="MqJz/s0v";
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 00FC04339E;
	Thu, 22 Jan 2026 11:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3FBC4AF09;
	Thu, 22 Jan 2026 11:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769081296;
	bh=s85LSQ98zPehLqlPlUskxnpBekc7C4QKSHYgSt9xYsM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MqJz/s0v6sq3IjiwE/1KDGRE5tGn717LYQ9DSw1c/gCfcHl7AQX7UIqU/3sKNwX62
	 st78LAoeoCBT/RMyxGL4Jt4J1shCkBUXFS6k4+faQZXLh0LRl8wqGtbHfixknzsOK2
	 Ju8bGpTiChCXjQlVWZO6nMck18nb8HEVN8kpoPm3XLWkbq5dkAnpaOjsHZ4KuzdUox
	 N4pTs8DJ8PQBFX3yw+HPtNqCyBCZN7dYppDSUKAuzn/uiF7zVSLKHNJyWgjERZs+9y
	 eKACb8rBYpNEXbbuv3GaGCOpWvRh9GfdWzbrq82ZtmVZ+//dmMXaqfCwDOk0dJox7z
	 tM8n1SEXjcbgg==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 6775EF40068;
	Thu, 22 Jan 2026 06:28:15 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 22 Jan 2026 06:28:15 -0500
X-ME-Sender: <xms:zwlyaThW56DjQo1FzLP3FyaL4liFZMOQnJjLm0G1JXM2XVQslYnucA>
    <xme:zwlyabYk1YPnsTjqQc_wAEtyYQ_cFBexo35NIgQ4rW_8-5SmcFLENg6jDfhkU2HPn
    q1d5wLbKBxF3ePq00xhLS7yDtHqbeNM-aYLUtmWtVvwk4JVy6gZHB8>
X-ME-Received: <xmr:zwlyaccrNXmxqjReNxu4sy_ER45Ds_tr7_M0-iS0_jN49imbQ8dNOuRFQxdSRA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugeeitdegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtoheprghkph
    hmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegurghvihgu
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:zwlyaYC118H7-MgDnUXGH-gvbhXqnoGxJf7sHEIdS6hqxNGy2SFG_w>
    <xmx:zwlyacUykq35UA0FS8CyOaGXw1_29u1Paj7-oe2Tx4bT15ey7l6oJQ>
    <xmx:zwlyadXF3YL3ac-lhXq1PTg4qwlkIwjYyPJupjDFO62Mnv9zwZbR-Q>
    <xmx:zwlyaf9jqNbLLyfNgrqu5iG0xLjIYCbUzh9JTxHHD3iMK2bVLYnYwg>
    <xmx:zwlyaT8IAtQhHCfGmFYwJxJAiNEIj4T-KgMWLWLFxElfQkB-wW63s63q>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Jan 2026 06:28:13 -0500 (EST)
Date: Thu, 22 Jan 2026 11:28:06 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>, 
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv4 07/14] mm/sparse: Check memmap alignment for
 compound_info_has_mask()
Message-ID: <aXIJY5irR0obgdQe@thinkstation>
References: <20260121162253.2216580-1-kas@kernel.org>
 <20260121162253.2216580-8-kas@kernel.org>
 <71F051F2-5F3B-40A5-9347-BA2D93F2FF3F@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71F051F2-5F3B-40A5-9347-BA2D93F2FF3F@linux.dev>
X-Rspamd-Queue-Id: 3701D140009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: tmejbbxdn7gwiyemo4tawru9n41pws5i
X-HE-Tag: 1769081298-134289
X-HE-Meta: U2FsdGVkX181/R0pU/LeNbmV1yxJNin82MVPRR/21R1HrZ/m3iGqJF94SKSjWJNz2yHcvC+7lxnDmkkmmctgpkJ3reSox6V7KHK2tc3n7PcZ3cKY11lDC5Wxo6FPVaF9M3TzhSSM5l3dNu7UMsDoQV5n3YuspJ5vjMUSL7TYlLk1UIn34a4vYl0rGFri2REDlA30rCIfOcHyALoPuUSR62/+BL01V2LvEfDParyqQ1iOwMKupXQXstqtz3SMY/0NqIqIz1lGdxtwrnEc5KDj+37uCpNvvV9CPy95gTt5FJggSngN0J1lQYh587rHBvRnfUPDcJAqqXlQiCNk8OuqbGs31FB/4RHl3p+5wJXOevKIeDGsqnti7H6/qYymS3eXGdfqQvD+RZ5ATv45odGsd9i0xAQGYQAlXVUQJHdDiEZbIIK8VckNTI+hn3dLPr/a3TmZ5PMIeyBXvjkoXk702nRL76al64pxdhrv1nKftOOjIuH0cUKT1NoBL81VDqRxFd3pDWdJ+Y0weFkdAz6nrL+qpr+O9FnLwtB/WSoK4ymLQEMbW422b/c5KoDrSs8gove3P8PseX22FUHmHtNC0Eky4Ysus6LmJsJ0GpNXSMLPf0fUrpLnMt1pXdR0vxN6IJz/Hs/7qbpwdIrHpj5SVFmtPBPaJMD5+0BsUYcXXCCbXHN5MtAd4nzpSFxHAG5GaiHku1xEPHL5pbEb60DfNRAVpM2qXWxjrApgyf5WjtRq7o8/rEDbNTuGOMwyzGdXBJN6XZM1lKLiB6T8hgE6NGLV1U5AKX4WMpktD8y+1JZDp+y7xPQMoYvjjfnKhl6lXglQll82A8kEzmDWQOUXWdsP2sEhtsC+KofcaWLdmtYWCQ+Me110Xi/eVaDXsOWm/haCPQxle2mzzojQerYPmyvDzl/OkMCvB3tnb5kRIX9DDin473XVgb8C2wFpaAB8/bCJPi3Z1pEEKxlqjsX
 To+Hok26
 QX1RyT9QflhOvW9/kCWzf9OHCSep5BmnCiZct489ubrZ1zbv23RjjWi6NeNIvj1Bb0BGSqGhuyFIIuzTNOsR4SygWyLdlIvz5yeSJWp5YMLIXN+eL/uHP2Uhv//iUt3bOYhGUUZ340XwSP275gAp/1aZRC5Fv/fQdKE7UpCjOSRyjWm2wrimXU3UGi5cVx2hXKQLyVggs6YYiR3ey98klgjC0Mncrf5lv2CD9aUY3X5s/e73af2xcKGX6OAwoKZzHJSgJbzaBAzyf450I8SoRja+L8nQu11c2M7viNpDWH5b78IA3BoUoV/MNZU6p7lo8T+Uc9cjNXeVtzoeoCozWvrlZRPGYVIVXBOu8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 11:10:26AM +0800, Muchun Song wrote:
> 
> 
> > On Jan 22, 2026, at 00:22, Kiryl Shutsemau <kas@kernel.org> wrote:
> > 
> > If page->compound_info encodes a mask, it is expected that memmap to be
> > naturally aligned to the maximum folio size.
> > 
> > Add a warning if it is not.
> > 
> > A warning is sufficient as MAX_FOLIO_ORDER is very rarely used, so the
> > kernel is still likely to be functional if this strict check fails.
> > 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > ---
> > include/linux/mmzone.h | 1 +
> > mm/sparse.c            | 5 +++++
> > 2 files changed, 6 insertions(+)
> > 
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 390ce11b3765..7e4f69b9d760 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -91,6 +91,7 @@
> > #endif
> > 
> > #define MAX_FOLIO_NR_PAGES (1UL << MAX_FOLIO_ORDER)
> > +#define MAX_FOLIO_SIZE (PAGE_SIZE << MAX_FOLIO_ORDER)
> > 
> > enum migratetype {
> > MIGRATE_UNMOVABLE,
> > diff --git a/mm/sparse.c b/mm/sparse.c
> > index 17c50a6415c2..5f41a3edcc24 100644
> > --- a/mm/sparse.c
> > +++ b/mm/sparse.c
> > @@ -600,6 +600,11 @@ void __init sparse_init(void)
> > 	BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
> > 	memblocks_present();
> > 
> > + 	if (compound_info_has_mask()) {
> > + 		WARN_ON(!IS_ALIGNED((unsigned long)pfn_to_page(0),
> > +    			MAX_FOLIO_SIZE / sizeof(struct page)));
> 
> I still have concerns about this. If certain architectures or configurations,
> especially when KASLR is enabled, do not meet the requirements during the
> boot stage, only specific folios larger than a certain size might end up with
> incorrect struct page entries as the system runs. How can we detect issues
> arising from either updating the struct page or making incorrect logical
> judgments based on information retrieved from the struct page?
> 
> After all, when we see this warning, we don't know when or if a problem will
> occur in the future. It's like a time bomb in the system, isn't it? Therefore,
> I would like to add a warning check to the memory allocation place, for
> example: 
> 
>   WARN_ON(!IS_ALIGNED((unsigned long)&folio->page, folio_size / sizeof(struct page)));

I don't think it is needed. Any compound page usage would trigger the
problem. It should happen pretty early.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

