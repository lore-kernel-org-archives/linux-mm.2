Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E19FEC1EB9
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 13:52:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02E616B0092; Thu,  5 Feb 2026 08:52:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00F986B0093; Thu,  5 Feb 2026 08:52:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E72056B0096; Thu,  5 Feb 2026 08:52:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D4CEE6B0092
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:52:41 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 76BEC1404E9
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:52:41 +0000 (UTC)
X-FDA: 84410543322.04.F8506EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 86B834000A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:52:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=szZPoJaf;
	spf=pass (imf17.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770299559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ZbaW+dzHbaMNGr9m14TpmrLhm08sFwnwom0N8lMgNw=;
	b=Emg+xJEKh/77UOoQ7IADIhsQ2rRAAk1/ujlKMIAqSySeHHs69/U84XzYCZcZeKReZRi3bR
	O3MAGG1bEBf9JahvTmH2DNrzqQNS/MEvYd6PevmL0I9C9//OpsY+zCz+oLfv9StJOMZuwz
	qXhoJD9DZU0cISOA2/y5SPyyBTUfbOk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=szZPoJaf;
	spf=pass (imf17.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770299559; a=rsa-sha256;
	cv=none;
	b=FhodPqpYq0QtoqFs86mg1W720Wb6XXcqLXmnQDVzNTKeERPyLkcmgLwBaFtnJamNmvM3J+
	zTP8rJgJyaZsho0IXt1pYHWeXOB45ut8bH53u6KdQjETp6MxG9EdB/LZeLm0R0Y+j6R9Y6
	YnOp6dlvX/BgYHKEOiFH4EJ4E9bpxOY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1370A60138;
	Thu,  5 Feb 2026 13:52:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C81DC4AF09;
	Thu,  5 Feb 2026 13:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770299558;
	bh=SWTU0hoYf/UnGmVIbKL9BuYlq2a5aSmIMAh2fyWcba8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=szZPoJaflynZpd82roRpeUy08KECBeN6DrO1YMzpPoPANaWujbeGfuQmbZCRKFm+s
	 duJZyo9/LXtgDSLHO00eZEMWMJwleOnZuwy+KBE/pAxUKEzLlWj0/ffpG6/sHNcvox
	 yrUznFEFXMBbes9e1CKGFJPNb3J9ebrh/oiWzwk7Dm5Euy3eVGGRdQwE6260rulEC6
	 GJNIWN8JeIwlp330LvL1yVfmDkVrkP8xxPRZFmuXo5IaARIIQ1NT57cGAXfY0IccGS
	 D7W2/dFVPCSuaLW/EckAnJNWZPBz42C4jhLMle3AYv1De76xkTkTk1Us8q4KHMpA/m
	 /sRwHCCCG7d/g==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.phl.internal (Postfix) with ESMTP id BA787F40068;
	Thu,  5 Feb 2026 08:52:36 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Thu, 05 Feb 2026 08:52:36 -0500
X-ME-Sender: <xms:pKCEaZTYTZ4IdYhPmFOtDhYpWfv4VFHVKZqyS-hSNC4z-tE8UR0vew>
    <xme:pKCEaWfpyO5I-lTzDqJVQOdI5AoM4kEpvx0mv0EgMXwJIhd1OJyrVgj7O33_oTnr0
    qNJjcVrzz3R_PAMsVcMZpZEbzO8-mi1x_xqOV80kF4S-1tGt5mHFdE>
X-ME-Received: <xmr:pKCEaZ74g6CGqmIPHCouJ15dBueoscoDiYdrYOV8edikmGPwvoxiCNcWt9fpAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddukeehgeeiucetufdoteggodetrf
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
X-ME-Proxy: <xmx:pKCEaeeur9pRhbizjFCCinU-IuCYrPMXf4IBShFFSog8cvq7XVScQQ>
    <xmx:pKCEaYAfHScjWLu3e9YOFE8w4RCHICCAsBJ9eTDkLVfyndU7yW3xOA>
    <xmx:pKCEaSHx5WhMPKTaoiKiwPhHa0FF22br4dAcmB3NaDUAA6t-_JUcvQ>
    <xmx:pKCEaYip_49tpAQBrIqS3y5WPakF-TN_GGYetR1lV7ES2iPnMSSq-g>
    <xmx:pKCEacs12NYuU7aC8364rHxeHnpUOW0I17oXjZq81pJTM6rj4qukWIfw>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Feb 2026 08:52:34 -0500 (EST)
Date: Thu, 5 Feb 2026 13:52:30 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (arm)" <david@kernel.org>
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
Subject: Re: [PATCHv6 06/17] LoongArch/mm: Align vmemmap to maximal folio size
Message-ID: <aYSgQknBNs5r-Tf5@thinkstation>
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-7-kas@kernel.org>
 <2ce0e684-de54-43ec-be7d-c58bbffb3f4e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ce0e684-de54-43ec-be7d-c58bbffb3f4e@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 86B834000A
X-Rspamd-Server: rspam07
X-Stat-Signature: prhgfnru7cdm61uxhuh7mmiuu98f1xaj
X-HE-Tag: 1770299559-117626
X-HE-Meta: U2FsdGVkX18rilVO4eOT4lbdEQQJJ3dyHENknVlb74UFQLA/i+BfA1jG5DaW4AtwWzryJ5HJiZNw8EZzQuFIefbdndhd44X3uTBAM1VPDpyAMjB2AScUHjKpnpZO/BAQ01S8lvcV4PRe196kE4tyykz/MoJUj2ucgKYgQAWyjRqZ6ziwKKDQ6INdkUlbX5dQogZSDRrUH/KEM7KJG/vEBkXAujHx917iedyReL0Cmea6633stc3NQUbo1ggPTaAUVT9pM1OM5YzYyB3LzGwMu1/gNcr4ikPIAevGs1wy/QjXRAGK/AZy9HitL1Rrma4HlSpky/O+YUXmJnS5taipAhbL3UBkRurcRtixvl7SrLVm+rBMSsFtQ/swpMeVDUTq3horj/SIl/QPbsRBJ1278FtwmNoA4W0kLGwl/H4NECoP8JHBqyBGUoig8sM+V9nPYoQcl0ScjkSbCa9GDCyNQSCAOMQU+gWF40FM5UFIQruq+YWQCkmNZgD9xgkb3qVM1cmAqoprLFlL3+qlT7xBZljdOAvBy23/w/4jodJ+4TYsuuXm3soPJhhAcT9/Tnjm183xVGwEkQgDNOIVmCaVAilV4XJUriCJsByUS7TMIHbv2FPPUJnk880CkLWCIdb85Ce/m6VjgU3/P9IzZmyGdtrQaZjjFhnw3pLUZN1L3syPfvNx4/abyxD2GxZPvDm2VzijjQ3r4AiYTu4XgLH+3mpbZNZGWKizFGPeRMgnHerFHKj4Mwwyo9Z5tNUVDFROPKCh0mFeh1kTOWH8RIIoNvQidb6e+Bz4f3IFXq1s8h+MqOg5RyYmnbN0pdUv+OisNw+6Hg5bOMlIITVH2V9UlYIUOmN/jCP0FWcUvgWBDIBFjvGRT/Bb1ge/rrLHHWDvyra/cgZzjOfffGRsGvW2WJTbpcShBt4rI3GqH9VVYF95I2oyfNLNhqSxPHvjQTjP1M9yo97nxqnGhRJUABq
 JC5yfMaP
 7htfKTCRsxPnOQOt1U8tMvAXTnsLDu3p1pS1nMrKZA8W7vEYCcNx9kf30eJJ7uCN5O2L9uEy1MP4ErRRngRNEl8tnhp/eT8Dq6qhFc/JlizPHleVwfvMWnz2SRGPS72jxZdH+tEszZcWspaTBVUJ52Th0pYmvGCOriLUeaLfzMIKa7DIptnrNQd0hcR3wi4QTl+eNu1ZQNwPNfYRZ00d1raz9MlfZtNvdk6dAr9t1BwfjysFkhIZ/K6NinZ9LjHPdKb+de351jTvql5AEQ7i2S9D2r0ActO8c3251uS2NotmGL5g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 04, 2026 at 05:56:45PM +0100, David Hildenbrand (arm) wrote:
> On 2/2/26 16:56, Kiryl Shutsemau wrote:
> > The upcoming change to the HugeTLB vmemmap optimization (HVO) requires
> > struct pages of the head page to be naturally aligned with regard to the
> > folio size.
> > 
> > Align vmemmap to MAX_FOLIO_NR_PAGES.
> > 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > ---
> >   arch/loongarch/include/asm/pgtable.h | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
> > index c33b3bcb733e..f9416acb9156 100644
> > --- a/arch/loongarch/include/asm/pgtable.h
> > +++ b/arch/loongarch/include/asm/pgtable.h
> > @@ -113,7 +113,8 @@ extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
> >   	 min(PTRS_PER_PGD * PTRS_PER_PUD * PTRS_PER_PMD * PTRS_PER_PTE * PAGE_SIZE, (1UL << cpu_vabits) / 2) - PMD_SIZE - VMEMMAP_SIZE - KFENCE_AREA_SIZE)
> >   #endif
> > -#define vmemmap		((struct page *)((VMALLOC_END + PMD_SIZE) & PMD_MASK))
> > +#define VMEMMAP_ALIGN	max(PMD_SIZE, MAX_FOLIO_NR_PAGES * sizeof(struct page))
> > +#define vmemmap		((struct page *)(ALIGN(VMALLOC_END, VMEMMAP_ALIGN)))
> 
> 
> Same comment, the "MAX_FOLIO_NR_PAGES * sizeof(struct page)" is just black magic here
> and the description of the situation is wrong.
> 
> Maybe you want to pull the magic "MAX_FOLIO_NR_PAGES * sizeof(struct page)" into the core and call it
> 
> #define MAX_FOLIO_VMEMMAP_ALIGN	(MAX_FOLIO_NR_PAGES * sizeof(struct page))
> 
> But then special case it base on (a) HVO being configured in an (b) HVO being possible
> 
> #ifdef HUGETLB_PAGE_OPTIMIZE_VMEMMAP && is_power_of_2(sizeof(struct page)

This would require some kind of asm-offsets.c/bounds.c magic to pull the
struct page size condition to the preprocessor level.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

