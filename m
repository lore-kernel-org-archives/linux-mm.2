Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0461FC87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 08:27:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BDDA6B00C6; Wed,  6 Aug 2025 04:27:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 995C96B00C7; Wed,  6 Aug 2025 04:27:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D2916B00C8; Wed,  6 Aug 2025 04:27:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7EF1A6B00C6
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 04:27:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0BF531A04AF
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:27:16 +0000 (UTC)
X-FDA: 83745652872.23.A879A17
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1A6D8120010
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:27:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=UPHt9F6E;
	spf=pass (imf29.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754468834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JYF+CftJKgFMgDaCOhrQT1FCHgVWsqIPp5y9Z4UMf48=;
	b=kz8wyLyFu7Z1DyuwLCq7tj6M5LW0jtw6HSTBZWsV1EuPJSVhTwVlomg06sPkfZ+P9W2NE1
	VHT1WcoPJ7cu16BiB8vrtmgdFH6InF25qW/DMbqr0t6r0tGNtoaRV3b1gpd4Q0OXcwuREc
	rnR5TrtFTJQIv9s3yzBFgTuFycXv5Ws=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754468834; a=rsa-sha256;
	cv=none;
	b=IIU0R+uLY/y/tMiyX9QNKsL7BfLHWycj5bpDZo7ya8HW+YWeBa72zXMPgClFc0hQ8Nyjqn
	rYUlc+iOqbkESE6aBDU4Aq6xx+aF/byM7cIaBY4Mve86MIaHqG2CLRDXr5csiVlJSlt5FF
	0vyx4uInBAh8BG4SMuV/qivy47db+5A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=UPHt9F6E;
	spf=pass (imf29.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4bxk196VNwz9srK;
	Wed,  6 Aug 2025 10:27:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754468830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JYF+CftJKgFMgDaCOhrQT1FCHgVWsqIPp5y9Z4UMf48=;
	b=UPHt9F6EtzExdOuIYi1Ccy7Bf1XqtaljYjxNNI6TLSxDSk0tFj0UH5gexbuveR4L1UBI+n
	82EHQynVP3NGTZWK/JA3Wb2RpLa3LFp9GcqB0GBvhni6eAxyP+nIcFA5lTT/JEAxM7TTI9
	x8KdJOXHNK26wYwkajZXLy7UJ496uGF1tV8TCuhan7XZRQZwBqsnHcv4eG4C+LegnefdR0
	SrNUGNQCeJYmhfCJxq5XjHqxr5Xd3wVYDlybEUJQYYL9fD4L7LD3Iaue2pGgk+TmEAU+UQ
	OJp0utGZt0Lcm1wxxt7ngHrqd2/VuKLXFvoUJIbKxngnezf5Y2VHTFFrLUzhSg==
Date: Wed, 6 Aug 2025 10:26:59 +0200
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Michal Hocko <mhocko@suse.com>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, willy@infradead.org, x86@kernel.org, linux-block@vger.kernel.org, 
	Ritesh Harjani <ritesh.list@gmail.com>, linux-fsdevel@vger.kernel.org, 
	"Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de, 
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH 3/5] mm: add static huge zero folio
Message-ID: <v45bpb4aj734gb4i7bp2fgzo33mapn3oljprkvtrzk2r2f5p24@5uibrp7a5wfh>
References: <20250804121356.572917-1-kernel@pankajraghav.com>
 <20250804121356.572917-4-kernel@pankajraghav.com>
 <558da90d-e43d-464d-a3b6-02f6ee0de035@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <558da90d-e43d-464d-a3b6-02f6ee0de035@intel.com>
X-Rspamd-Queue-Id: 1A6D8120010
X-Stat-Signature: bnc5bw39pnsj3rkuw3meukicdycg4zcy
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754468833-96535
X-HE-Meta: U2FsdGVkX1/852i27KuAUHgxEHgbAmDDc6p6zZCHIe/v8mXrH94lfJ6QeTMcaKN616ukK800YnRSr6TWFXSpV7VNgT6YFDxK00KlUDSTKAbleJEVOkTaYgyQt1C0U6ufsQmz0+Pzy1yhCUWGTqEEujwomJtVH/pr0YKIhrtHBpUDncCKfuQtniQ0oWSlLJ10TIhHezzBlGGcWIUUPh8EjIYQYcEpXhG73WOblzc9yi+pYJEIOotlKLbRwt9fJmQFrDQTd78WpUSJeU4Fs+rWM3Hg3+qmRHYrD0QY9LNg7mlyTwBKx6VahiYFM7bMvO2HY6nGp1kKnb1HSDVemyXh2K59O8u+3TCr+McG/ZXaF1cWpRkVViY1uoJHqAp++3d9t2zaOg1si+GnveztR0Uv6b6FTbFJ8KJ2lFEQ1rgcQbhD/zUqconIrqHRN6/SDy2vDF7K53LMhb8IQo3GIlvHXbuEKtm5DL5SimQ/o6WtIwsRwvcgHcsp/Tb9wTkcdeMsRNXLQRE84n3MCB4TVZk7ZkWKMSfUyGsjSnbkgddDfHxyh+xw5M1Funi+F/Zi9JvncG5ta3u0ctYcjxwEefk5Chop8cUaFs8wD1lO9FohteUM9Bakv4hVU+BnYk1QduiSousc8q/hiVND30DISW23O6NkgBp7DCMTVhBFqbLQQCTyL54EXq4omi2kI+/ST9IYt5Iyk7s7HIXZwLndI4IrDv8uf4SOlTs4CnTgaQrxJIWxd0QaUPcUVg1RWyBMnVFtVFN79fJZ2Iv0T77X/G90OB2z1t0oNS1ungZuFUGbj/AQMYri/CbDgzjAMypGUMLr4Phb69ZSu5mcNidRU6DsYLJCkZmDP88UB1TIL5JWB0fwOc+HuyzmwGSVVWOM67xrVdItb1O0gVv8D+vYCPkhTZOwDTNG9k76fTe/DxtI//KPZP5/cBTuHQnKaxNC/LGYL7jYYtKD30DaP5stmXG
 hRiqYctk
 tsl2G2ArKs7K/MrTh8OX1FY9trF7OV6Y9D/npWk0npqZu+bIrOmMrq5qOkj+6R33bMQKtNc3iPYgsR1juJ6Kn9ENjFV4YDHYMxATlKdL9yAFbISzNrOTDDlreDOGeCpCXTdrHaSIx3A5CtzInZC1f1/sG/j3dlra1VJzehkkXHD/rPSO5/7dugmahawrSmYePK75wJ5nWTuXt231ikNz5fnxL/i51FaQmd7aO6kegoAuhB3IAA74fJKTIJDJ4ohYSvGdxHe/M+LpTLYaxS+7IUMdu8QUI49i6O8CjA+ZCnXhfIVlUJPEYk7m75BuX53oIO+Vl+6HbPXqVTmHTIDbtnQsz2ydioISgASyjjS7vUgIr2LpbGkphVCsbi9XyGQHpIZDIvKwglbThE/9I9BbwfkLdpycgzinnxspUXhjelwjxfg3u3JqgxrzB1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 09:33:10AM -0700, Dave Hansen wrote:
> On 8/4/25 05:13, Pankaj Raghav (Samsung) wrote:
> > From: Pankaj Raghav <p.raghav@samsung.com>
> > 
> > There are many places in the kernel where we need to zeroout larger
> > chunks but the maximum segment we can zeroout at a time by ZERO_PAGE
> > is limited by PAGE_SIZE.
> ...
> 
> In x86-land, the rules are pretty clear about using imperative voice.
> There are quite a few "we's" in the changelog and comments in this series.
> 
> I do think they're generally good to avoid and do lead to more clarity,
> but I'm also not sure how important that is in mm-land these days.

Yeah, I will change it to imperative to stay consistent.

<snip>
> >  static inline int split_folio_to_list_to_order(struct folio *folio,
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index e443fe8cd6cf..366a6d2d771e 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -823,6 +823,27 @@ config ARCH_WANT_GENERAL_HUGETLB
> >  config ARCH_WANTS_THP_SWAP
> >  	def_bool n
> >  
> > +config ARCH_WANTS_STATIC_HUGE_ZERO_FOLIO
> > +	def_bool n
> > +
> > +config STATIC_HUGE_ZERO_FOLIO
> > +	bool "Allocate a PMD sized folio for zeroing"
> > +	depends on ARCH_WANTS_STATIC_HUGE_ZERO_FOLIO && TRANSPARENT_HUGEPAGE
> > +	help
> > +	  Without this config enabled, the huge zero folio is allocated on
> > +	  demand and freed under memory pressure once no longer in use.
> > +	  To detect remaining users reliably, references to the huge zero folio
> > +	  must be tracked precisely, so it is commonly only available for mapping
> > +	  it into user page tables.
> > +
> > +	  With this config enabled, the huge zero folio can also be used
> > +	  for other purposes that do not implement precise reference counting:
> > +	  it is still allocated on demand, but never freed, allowing for more
> > +	  wide-spread use, for example, when performing I/O similar to the
> > +	  traditional shared zeropage.
> > +
> > +	  Not suitable for memory constrained systems.
> 
> IMNHO, this is written like a changelog, not documentation for end users
> trying to make sense of Kconfig options. I'd suggest keeping it short
> and sweet:
> 
> config PERSISTENT_HUGE_ZERO_FOLIO
> 	bool "Allocate a persistent PMD-sized folio for zeroing"
> 	...
> 	help
> 	  Enable this option to reduce the runtime refcounting overhead
> 	  of the huge zero folio and expand the places in the kernel
> 	  that can use huge zero folios.
> 
> 	  With this option enabled, the huge zero folio is allocated
> 	  once and never freed. It potentially wastes one huge page
> 	  worth of memory.
> 
> 	  Say Y if your system has lots of memory. Say N if you are
> 	  memory constrained.
> 
This looks short and to the point. I can fold this in the next version.
Thanks.

> >  config MM_ID
> >  	def_bool n
> >  
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index ff06dee213eb..e117b280b38d 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -75,6 +75,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
> >  static bool split_underused_thp = true;
> >  
> >  static atomic_t huge_zero_refcount;
> > +atomic_t huge_zero_folio_is_static __read_mostly;
> >  struct folio *huge_zero_folio __read_mostly;
> >  unsigned long huge_zero_pfn __read_mostly = ~0UL;
> >  unsigned long huge_anon_orders_always __read_mostly;
> > @@ -266,6 +267,45 @@ void mm_put_huge_zero_folio(struct mm_struct *mm)
> >  		put_huge_zero_folio();
> >  }
> >  
> > +#ifdef CONFIG_STATIC_HUGE_ZERO_FOLIO
> > +
> > +struct folio *__get_static_huge_zero_folio(void)
> > +{
> > +	static unsigned long fail_count_clear_timer;
> > +	static atomic_t huge_zero_static_fail_count __read_mostly;
> > +
> > +	if (unlikely(!slab_is_available()))
> > +		return NULL;
> > +
> > +	/*
> > +	 * If we failed to allocate a huge zero folio, just refrain from
> > +	 * trying for one minute before retrying to get a reference again.
> > +	 */
> > +	if (atomic_read(&huge_zero_static_fail_count) > 1) {
> > +		if (time_before(jiffies, fail_count_clear_timer))
> > +			return NULL;
> > +		atomic_set(&huge_zero_static_fail_count, 0);
> > +	}
> 
> Any reason that this is an open-coded ratelimit instead of using
> 'struct ratelimit_state'?
> 
> I also find the 'huge_zero_static_fail_count' use pretty unintuitive.
> This is fundamentally a slow path. Ideally, it's called once. In the
> pathological case, it's called once a minute.
> 
> I'd probably just recommend putting a rate limit on this function, then
> using a plain old mutex for the actual allocation to keep multiple
> threads out.
> 
> Then the function becomes something like this:
> 
> 	if (__ratelimit(&huge_zero_alloc_ratelimit))
> 		return;
> 
> 	guard(mutex)(&huge_zero_mutex);
> 
> 	if (!get_huge_zero_folio())
> 		return NULL;
> 
> 	static_key_enable(&huge_zero_noref_key);
> 
> 	return huge_zero_folio;
> 
> No atomic, no cmpxchg, no races on allocating.

David already reworked this part based on Lorenzo's feedback (he also
did not like the ratelimiting part like you). The reworked diff is
here[1]. No ratelimiting, etc.

> 
> 
> ...
> >  static unsigned long shrink_huge_zero_folio_count(struct shrinker *shrink,
> >  						  struct shrink_control *sc)
> >  {
> > @@ -277,7 +317,11 @@ static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
> >  						 struct shrink_control *sc)
> >  {
> >  	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
> > -		struct folio *zero_folio = xchg(&huge_zero_folio, NULL);
> > +		struct folio *zero_folio;
> > +
> > +		if (WARN_ON_ONCE(atomic_read(&huge_zero_folio_is_static)))
> > +			return 0;
> > +		zero_folio = xchg(&huge_zero_folio, NULL);
> >  		BUG_ON(zero_folio == NULL);
> >  		WRITE_ONCE(huge_zero_pfn, ~0UL);
> >  		folio_put(zero_folio);

> 
> This seems like a hack to me. If you don't want the shrinker to run,
> then deregister it. Keeping the refcount elevated is fine, but
> repeatedly calling the shrinker to do atomic_cmpxchg() when you *know*
> it will do nothing seems silly.
> 

The new version[1] deregisters instead of having this condition. :)

> If you can't deregister the shrinker, at least use the static_key
> approach and check the static key instead of doing futile cmpxchg's forever.

--
Pankaj

[1] https://lore.kernel.org/linux-mm/70049abc-bf79-4d04-a0a8-dd3787195986@redhat.com/

