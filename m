Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 026D1FD8740
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 11:28:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31A596B0088; Tue, 17 Mar 2026 07:28:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F2676B0089; Tue, 17 Mar 2026 07:28:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E0AB6B008A; Tue, 17 Mar 2026 07:28:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B90A6B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:28:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C084913B480
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:28:45 +0000 (UTC)
X-FDA: 84555332610.28.63A9680
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id AF2721C0003
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:28:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hdIGeuR5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773746923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I9ks/T4YP0lNoMvxyMbbQ32C1Tx190z0EOoIY0aEysg=;
	b=aaRpfuCnUEgh0UaxVppulHDTMbAQnheBHQ0809CwexmOkuxx0Kv1x4E7TLT1bjYUshI2Ks
	hJGUotPNsgNQ8HnBHJ+8yH+TePRLsU+LNtEIMTf+YXp96XKTdi/wW20PKkfl/RZ8yObIIi
	6dmO9dpZeY+5qfXkMSvDwUijtZoONqI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hdIGeuR5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773746923; a=rsa-sha256;
	cv=none;
	b=vgdsLcR+/H6WEh2Jf5wCIrFVanUpbO+WggBbHRAxVQnZgJvtx8RGrDteGbosAvRnOKXz9u
	R3ecr1z/6UG7RjMk1fY0qcW2A8TA6AtaEjJvi1bN7x7+czik9nqZFjzPmG0/RIyrvFGHbX
	0HWT8iz7Zicpy1eV0OCQduNuveKgBDA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F4F74374A;
	Tue, 17 Mar 2026 11:28:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C537EC4AF09;
	Tue, 17 Mar 2026 11:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773746922;
	bh=32qbYYZEgqHyAOOKzk5WrymnIe+x73RqYh712Mog1As=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hdIGeuR59iiqFhPnWcecegpZD30lBPjH6oyJgNrZ6sTuqfj67G8KwOQMWRpH66ln7
	 Tb+7rKSnyapJxOuOYPf0JqsZH2UEsi7+u7bYXa84wITJpd0GoQExdA157pROiQ0xUG
	 FkP/HT0QhUuw5NL2RQRZavEB2AO8Z6ynUUE65XnPSOjoNXoU74KUjQ+SHXoxtRuIUS
	 TOnUblaSujaS4wEbaEDE+Z0BBhVvhMdSbMomo10xrl9uEkH5esYJK4Bo9jOSvD5lO9
	 UHg+lN1Vc3K6yiC0r5V5MihGfutd9Xtk6BEwYZhd4ijbJ2iH45Yye6vueuxh2SZZSA
	 WmIwjPwb4DRKw==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.phl.internal (Postfix) with ESMTP id E28B8F40068;
	Tue, 17 Mar 2026 07:28:40 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Tue, 17 Mar 2026 07:28:40 -0400
X-ME-Sender: <xms:6Dq5aRezeypjqaoWwhIQjsBuBEhtrdSNLXG62S2ccj2KBrdeDFlkMQ>
    <xme:6Dq5aY74Fzu_kW2IqbfV7ADlOCPU3a5H6IRhoUJbaJFuIFM6vzTvk6CH4GA_9jHxe
    pdSR_A8fESh31IsvOjhte6pYMvlqQX2L24C8ZGztBbjCN7_vsrTO-o>
X-ME-Received: <xmr:6Dq5aRdI5bQ3PZ3PcWm9JNgk0qQj8TjCz4neksWXvW5aj-IlU9F2Xjfx8kX_RQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdduudefucetufdoteggodetrf
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
X-ME-Proxy: <xmx:6Dq5afB40A8o3F4M6vXhGQivGB23CU8zGa6dY7zbd2L7KjB6TmweRw>
    <xmx:6Dq5adGl3TJC6mmbn9eD1LlxwlRJZfuXH1_ME-MYxf98BtvkMSsgnQ>
    <xmx:6Dq5aXi4DU2MhQ1B_Ii0EIM91z-qBbr92LZM83CYfF-7lQlzf6SkjQ>
    <xmx:6Dq5afsxgNwr3DMB23qGX1nysq_EKzWatd4vzWcPpqaHXuIM_OQKzQ>
    <xmx:6Dq5ad_BUpkXLTbLl-0RPF25cJY_OlBhTA00Q_FsAXEWdi13FUI84bed>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Mar 2026 07:28:38 -0400 (EDT)
Date: Tue, 17 Mar 2026 11:28:34 +0000
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
Subject: Re: [PATCHv7 09/18] mm/hugetlb: Defer vmemmap population for bootmem
 hugepages
Message-ID: <abk58j2bV0sGabEU@thinkstation>
References: <20260227194302.274384-1-kas@kernel.org>
 <20260227194302.274384-10-kas@kernel.org>
 <4e52f70d-e0c3-471f-8073-68c0e9bc94ca@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e52f70d-e0c3-471f-8073-68c0e9bc94ca@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AF2721C0003
X-Stat-Signature: w9drryst8phzp7jikpnignt3pwaern5q
X-Rspam-User: 
X-HE-Tag: 1773746923-280448
X-HE-Meta: U2FsdGVkX1/QScQl0pQF20ysxAhYwLmRsj6nCgI/lULbsikvV5q+TU77CF7NFPMjAczsPUj/z8A2+eAS49Irey30vwcAIx/3qkjLvKD4NMnT/inM4Qmhx96ql6EOmkEOih+5a9vImnTzQHzDDCwrH4lFE09F0hLokF2SvK+y4/nAVY6V41ytSbYnpTuMqv8oYXzFKsq6SjRoHaSXoBpvcTRimMiJhPeeP44vONIo8+m/Zx8Rq8cKjnOe3jvbI6jKiuFKyuCQJuqiZ73Rwc6PAg3owIBOIWINhe/FE+Ko9iab+JMczjS4E15SSu7Jy7QKDesRRtatboW4SSAFYV78YXijlqfWNs0SezudFzsXr4SvOizpJjtFbYQDMdJecxUIM6YeQxnw7smmnbMoUVf9veJRQpirxjmLUjjWCGqtZhqiKQSv68BoAwKkCO1TB38HZw4JIqDVWG8QFxUFwHx3ikjlO6pAschLfC6XRL6jmIaf0V8EUWflkaHDcBnSgI6ssybduX/3rso+N9xZG0ha4MLRgqAYKq4UWJUmg8ip5/JQDZPpp9maNQaMB/shGci6xOGWz05Jxmc50xPYQvZDW8cUR8UCoKKi2/2kXse2/2+jwGNALWKDmRmyTWDNEtuoRRtthRCzrS4pKlplfn6TFPHqtG7UwZq2DjdYybcpnhqJotLpr4B+Kbj8OHsdb3zNLBWSwIu86KYOtj1PPFxmqIf9zH85GsktTpO49nF+Dz60xw9YQgQYxZEd+7fTawV0wK9sI0cGPvxVwH5LMU63S0EzQ8Urg1vyXGjK6sli6ttU5t85f90+wJZC2/q2mtNGgs1CyXCbzTdJpVT1CEwlz4G/CiYtz2uPQoD+jIgaKX4f/Mgpuj4Qfcu25LC44ol75tiSuHidTnVPIeGqTVBRLJ+f8HENLkvS9UQjUTx6r5qYRgDMMbjlDB/qtUhD5gqMz/k4fj4BQLj4rfgnjMJ
 v1ubNk51
 gMb7umiZV6P7CSMA6LWHHWYaT04MyBK0HXMVhZXmZJuTws56plIKsRrJpzf54jipXWN2at65Ot/EaHyvb7/Bm+MohInKlcVHwG0IZJKxhQ7AynflUROESIxEfWSLKbRNavq6idE4kUs1pPSeTKtCnFYLdbybuit/r51UFoaJWHnEsPAOrNUdrYxud7jGDa/N/NiG2PVznTJ0Xp/bhEhyxQnYGdcS1lpA4j7Iu0TyRw3IgVrk2Vxt3vk6LvEphFytNAxDRWeoONP0HhEACtxJUJQY1iyBzgR1HNZnY10/N1AUAzBk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 05:48:24PM +0100, David Hildenbrand (Arm) wrote:
> On 2/27/26 20:42, Kiryl Shutsemau (Meta) wrote:
> > Currently, the vmemmap for bootmem-allocated gigantic pages is populated
> > early in hugetlb_vmemmap_init_early(). However, the zone information is
> > only available after zones are initialized. If it is later discovered
> > that a page spans multiple zones, the HVO mapping must be undone and
> > replaced with a normal mapping using vmemmap_undo_hvo().
> > 
> > Defer the actual vmemmap population to hugetlb_vmemmap_init_late(). At
> > this stage, zones are already initialized, so it can be checked if the
> > page is valid for HVO before deciding how to populate the vmemmap.
> > 
> > This allows us to remove vmemmap_undo_hvo() and the complex logic
> > required to rollback HVO mappings.
> > 
> > In hugetlb_vmemmap_init_late(), if HVO population fails or if the zones
> > are invalid, fall back to a normal vmemmap population.
> > 
> > Postponing population until hugetlb_vmemmap_init_late() also makes zone
> > information available from within vmemmap_populate_hvo().
> 
> So we'll keep marking the sections as SECTION_IS_VMEMMAP_PREINIT such
> that sparse_init_nid() will still properly skip it and leave population
> to hugetlb_vmemmap_init_late().
> 
> Should we clear SECTION_IS_VMEMMAP_PREINIT in case we run into the
> hugetlb_bootmem_page_zones_valid() scenario?
> 
> I suspect we don't care about SECTION_IS_VMEMMAP_PREINIT after boot and
> can just leave the flag set. (maybe we wan to add a comment in the code?
> above the vmemmap_populate() ?)

I think keeping the flag is right thing to do.

SECTION_IS_VMEMMAP_PREINIT indicates to core-sparse that the section
should not be populated and it will be initialized elsewhere. Even in
!hugetlb_bootmem_page_zones_valid() we take care of it in
hugetlb_vmemmap_init_late().

And, as you mentioned, nobody looks at the flag after boot.

> Nothing else jumped at me
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> -- 
> Cheers,
> 
> David

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

