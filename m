Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05B99D4660F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 18:58:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 458AB6B00C1; Thu, 15 Jan 2026 13:58:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43A886B00C2; Thu, 15 Jan 2026 13:58:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 370146B00C4; Thu, 15 Jan 2026 13:58:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 23E556B00C1
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:58:51 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D1B1C14041D
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:58:50 +0000 (UTC)
X-FDA: 84335110020.01.1757254
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id B014D4000B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:58:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sasjx5xa;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768503528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0O1BWycOQ+2FbDcO4CnFz87blFngabaJrYDMzKbHL78=;
	b=TfcfrzUt79HDYEjyREYZrwtTdJJt0aNkhGC3eo7eMtz6VaA1qd0gzNTzuQqTfqjdgerfFC
	mJwNN1WDdtmZarqRAeOpihVO9srQOuVRno75wvBvr7c4h+8JoDEAIdkrCL1mlAjSPh6aii
	VbcO/FgIa87/AuAei1e5tWoG3ex6eH4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sasjx5xa;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768503528; a=rsa-sha256;
	cv=none;
	b=375mTq89ZF5gT7dHUfaVMGYF1/dtSAC3WMkBAChLkNfFyYshqhGPl7xokWYWAAYZsRDak5
	8ok21iHBX50rOhKhLqwjvA5w2fCnvdCJRMVsb9JtLny4xUsgWZZudVwXJcuNl+1a7ipZkR
	2RCVhdy8xzPjBsPxk0+xvbHXaIq/UzQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AE3E343E0F;
	Thu, 15 Jan 2026 18:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D872C16AAE;
	Thu, 15 Jan 2026 18:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768503527;
	bh=br/WucxsQfWbv74JcngU4crhnn9648apyx4EMg51Nd0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sasjx5xawln9vY0ejx/Uss1AiypYRhOzfEiYuYsXYHgmxP1CZhZ5XKDisjnbSeCEy
	 iJCxGE8JUkucMT8+AkTDkl7l8pbbjbU+ruToN9zlbEeiX0f0UEzWTj35jnQgVQMtOE
	 oJGSR2HdswH353jNfh6vK9Rqwug/Zz9V5EtqP2UVFpmW1guZixlvmbJYgpTg0w7Nzs
	 4ZzenwSYW7smbsxXPW4Ao+VJnm4OcheGsD/4AE+uhXAimMKHBgBJb/zrON86F4NlAe
	 cERjuNHflUlC6ZmfPypxdSLbDth4mDkKDZ+isK/yShOqJNN+lzuWNJTvdQbqWc3ovg
	 Vjyui/wfh216w==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 28396F4006A;
	Thu, 15 Jan 2026 13:58:46 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Thu, 15 Jan 2026 13:58:46 -0500
X-ME-Sender: <xms:5jhpaYljaUC2SCIpcZhjINK3IWcygkTtXXm5YnhRvkOJ6He9vERSvA>
    <xme:5jhpaZ59SdkBvcEhx7rssChPoYX-6jwLyns5j8G8ftrrUGHiVNDKaDfXRB8DxQNIj
    JY5j9bUSxa-d1NAMZTc3b5VJka1qu5jvE33uiL4IIBJamffO-VjwJE>
X-ME-Received: <xmr:5jhpaQu4OdAaxKToHrVdSVLsP8LNFZY5Pu1UvgT7VODI3wD8Q8Q3TEUq_I-nSQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvdeikeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinh
    hugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepmhhutghhuhhnrdhsohhn
    gheslhhinhhugidruggvvhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:5jhpafQpur2MUHsJnl9IgGl8z4rr86fNZdJpZzybljnSDNuGcWlirg>
    <xmx:5jhpadg-Su3xLTcrQyGKa84e-l9Hjym4yOqmPhbdBnVxAA0b3pdIYw>
    <xmx:5jhpaUacVMQOKqaibJXYkrZib5k9GCV-SvVDhJM72bFDZ9n9N7HZjg>
    <xmx:5jhpaXrIWTSyMdhOaisIzLbbdEIM5bqqChKe7u1d-ElYx_QK9ZsVOQ>
    <xmx:5jhpacxaOhipCeqCiezQ_fX_5p0ajN4ZLqSEISktNIGyaFOzWnNQTMuM>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Jan 2026 13:58:44 -0500 (EST)
Date: Thu, 15 Jan 2026 18:58:39 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>, 
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv3 10/15] mm/hugetlb: Remove fake head pages
Message-ID: <aWk1tZyFZOOkF0AH@thinkstation>
References: <20260115144604.822702-1-kas@kernel.org>
 <20260115144604.822702-11-kas@kernel.org>
 <30ae1623-63f9-4729-9c19-9b0a9a0ae9f1@kernel.org>
 <aWkhbWR-3fWjeTaE@thinkstation>
 <b10e3b2a-b298-4d27-b8ce-63327864c220@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b10e3b2a-b298-4d27-b8ce-63327864c220@kernel.org>
X-Stat-Signature: jw79sj1xtjnqxdzpseytq5agifm4x1ux
X-Rspam-User: 
X-Rspamd-Queue-Id: B014D4000B
X-Rspamd-Server: rspam08
X-HE-Tag: 1768503528-884764
X-HE-Meta: U2FsdGVkX18qpZHi8ieJY2VZ6qK8S/MfZEAf2rIj+t5z+6JtWDqME2QgEhbPgjnQrH/9UEJzjS7x65hq9uIwRlIZFceX6k7VjxOUxnoIhxcYJndEvTInS0DOqeyOH9KL03MyyRytYKx8E10aucG9Be8eYfcpHeZBQUji34WzSDZ/zMKg7Ds8X72ORZu0BdXI2SZMbEZoMOVzurVWlfM+HxwT6flh1zGmADzl99Bd/IDcZ46vsL+06YHj81Nxn8F4nAuOGe7SccrgBZakcHyoIceibvbA+O/gZ12D/nagSVrV1Bf+HzbEmIS1jbO4bhPxjJ2Rc+qEf/3hF8yhYELIZouQAufvW3rV8F8L4y2vZjIdTHG3NXvxoPf6Q7R0++Nn0PYLalrsdBT+fe0ADvs9R4JypZmNvoIEM8OuSHRrcQt3E9T/Zx5sYXOhmKLrg9cN594RsScKEFc8xBphCsXVVFV4L70zHZxHFe2ZZXifkITziBzuH6wnjrKD9XLIIjQGIfP5rdHMbAOvBpEhqm7B3LAKdJW+YhOXVpqIrdVbSlA8W1OnhT4AzitNWe/Z+nXLDOl8E+FwnvLqHs4edRpsmHSXAPY/gg87gPIWBosxlRItx9BYThC877WVC3dtzW4vs+cfZkW1vMXCYQ/3hINX9B6AggjU/KUHIvRTTMw8h72HO19TO8DXyJawfEejWnExftyzDmBbzSmr/4xcFg0Ak9gRsuzH5Jj+R38dPIptT1P24gcNlmvzOxk18eku2Ivm0xTts3FM8jdRD3BoYLF29/kOkxnvzr0EP9fjHQ9WCqABAQ8vqTb0mD4ZYhw2XD8aagRbIoxIgee5utf2if+g0KpcepWkxx/sqCr28d9RxrNZHAYB0qNy3NEoaNTXt+puUK5hcE0iA+BAakySVXJXSd+9XnnDW85v8b5GT/NAH3Lw0ZAb3Jv/8zHzrUZkblSJ7umxt52PyWmUwAdMx7F
 bLqQIdnM
 kpmtbUdUBqn3h7ZHAfCYqDkFRGjV8Qz2Tl9PVzFZRUcCYI+7saSnBmK+GL7z1lCPDBDrbFPGThACuzAufmPa8CFBEQGAn5e4jCjkwkHMaP5ddSAYcWsb7MUGc0rnSAyik9ZmvlPWduFWeU3YM94GtFaWkRwog69O/EZ7NzJQkZyLJmGs0tzhYpVY/yfNTZ0PZ9maBJ1oty0fAdPWeuMqGOftYRs0l6OqfpzF3wRoZFn+hvkrWFjC+uZ+qNeXgqOc0vDCyr1skEOisYxO58+z+lvwruFd0JZD5AUSh23b2mTn47bg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 06:41:44PM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/15/26 18:23, Kiryl Shutsemau wrote:
> > On Thu, Jan 15, 2026 at 05:49:43PM +0100, David Hildenbrand (Red Hat) wrote:
> > > On 1/15/26 15:45, Kiryl Shutsemau wrote:
> > > > HugeTLB Vmemmap Optimization (HVO) reduces memory usage by freeing most
> > > > vmemmap pages for huge pages and remapping the freed range to a single
> > > > page containing the struct page metadata.
> > > > 
> > > > With the new mask-based compound_info encoding (for power-of-2 struct
> > > > page sizes), all tail pages of the same order are now identical
> > > > regardless of which compound page they belong to. This means the tail
> > > > pages can be truly shared without fake heads.
> > > > 
> > > > Allocate a single page of initialized tail struct pages per NUMA node
> > > > per order in the vmemmap_tails[] array in pglist_data. All huge pages
> > > > of that order on the node share this tail page, mapped read-only into
> > > > their vmemmap. The head page remains unique per huge page.
> > > > 
> > > > This eliminates fake heads while maintaining the same memory savings,
> > > > and simplifies compound_head() by removing fake head detection.
> > > > 
> > > > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > > > ---
> > > >    include/linux/mmzone.h | 16 ++++++++++++++-
> > > >    mm/hugetlb_vmemmap.c   | 44 ++++++++++++++++++++++++++++++++++++++++--
> > > >    mm/sparse-vmemmap.c    | 44 ++++++++++++++++++++++++++++++++++--------
> > > >    3 files changed, 93 insertions(+), 11 deletions(-)
> > > > 
> > > > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > > > index 322ed4c42cfc..2ee3eb610291 100644
> > > > --- a/include/linux/mmzone.h
> > > > +++ b/include/linux/mmzone.h
> > > > @@ -82,7 +82,11 @@
> > > >     * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
> > > >     * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
> > > >     */
> > > > -#define MAX_FOLIO_ORDER		get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
> > > > +#ifdef CONFIG_64BIT
> > > > +#define MAX_FOLIO_ORDER		(34 - PAGE_SHIFT)
> > > > +#else
> > > > +#define MAX_FOLIO_ORDER		(30 - PAGE_SHIFT)
> > > > +#endif
> > > 
> > > Where do these magic values stem from, and how do they related to the
> > > comment above that clearly spells out 16G vs. 1G ?
> > 
> > This doesn't change the resulting value: 1UL << 34 is 16GiB, 1UL << 30
> > is 1G. Subtract PAGE_SHIFT to get the order.
> > 
> > The change allows the value to be used to define NR_VMEMMAP_TAILS which
> > is used specify size of vmemmap_tails array.
> 
> get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G) should evaluate to a
> constant by the compiler.
>
> See __builtin_constant_p handling in get_order().
> 
> If that is not working then we have to figure out why.

asm-offsets.s compilation fails:

../include/linux/mmzone.h:1574:16: error: fields must have a constant size:
      'variable length array in structure' extension will never be supported
 1574 |         unsigned long vmemmap_tails[NR_VMEMMAP_TAILS];

Here's how preprocessor dump of vmemmap_tails looks like:

 unsigned long vmemmap_tails[(get_order(1 ? (0x400000000ULL) : 0x40000000) - (( __builtin_constant_p(2 * ((1UL) << 12) / sizeof(struct page)) ? ((2 * ((1UL) << 12) / sizeof(struct page)) < 2 ? 0 : 63 - __builtin_clzll(2 * ((1UL) << 12) / sizeof(struct page))) : (sizeof(2 * ((1UL) << 12) / sizeof(struct page)) <= 4) ? __ilog2_u32(2 * ((1UL) << 12) / sizeof(struct page)) : __ilog2_u64(2 * ((1UL) << 12) / sizeof(struct page)) )) + 1)];

And here's get_order():

static inline __attribute__((__gnu_inline__)) __attribute__((__unused__)) __attribute__((no_instrument_function)) __attribute__((__always_inline__)) __attribute__((__const__)) int get_order(unsigned long size)
{
 if (__builtin_constant_p(size)) {
  if (!size)
   return 64 - 12;

  if (size < (1UL << 12))
   return 0;

  return ( __builtin_constant_p((size) - 1) ? (((size) - 1) < 2 ? 0 : 63 - __builtin_clzll((size) - 1)) : (sizeof((size) - 1) <= 4) ? __ilog2_u32((size) - 1) : __ilog2_u64((size) - 1) ) - 12 + 1;
 }

 size--;
 size >>= 12;



 return fls64(size);

}

I am not sure why it is not compile-time constant. I have not dig
deeper.

Switching to ilog2(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G) - PAGE_SHIFT works,
but I personally find my variant more readable.

Do you want me to dig deeper to check if making get_order() work
possible?

> Was this only a specific config in where you ran into compile-time problems?

I am not aware about any particular config dependency. Seems to be
everywhere.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

