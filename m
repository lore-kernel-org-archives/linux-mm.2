Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EB24CD484E
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 21:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78BE26B00B0; Mon, 11 May 2026 17:49:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73C786B00B5; Mon, 11 May 2026 17:49:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62AC06B00B6; Mon, 11 May 2026 17:49:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4E7936B00B0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 17:49:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0D6121A027C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:49:04 +0000 (UTC)
X-FDA: 84756479808.21.3B07CCB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 63ED81A000C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:49:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tomABWcT;
	spf=pass (imf19.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778536142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lMwaCdfhiE+OaCOJG5qgh49MeTVyC8n/eKLbWBjdDsI=;
	b=RmmaN+bF/xHlJXNEnOCn1tw7a3qejyVLXGRSTU3kFSfV2eEkTxOsH8UJuaLZ9x4Fbcl/2p
	N2h3VUf37VKPKe2+iW57MJRFBpOU7hiN1Wn6hiq6MyI57JYEolqp5A6JLWPYEfA42PvRd2
	l2DKwGin5FuU+CnUqQU7rcDtN8pBV7I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tomABWcT;
	spf=pass (imf19.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778536142; a=rsa-sha256;
	cv=none;
	b=FWddus7HumuP7oG6jCY0kW+K0bullYph6dGCJ4T+/92c50olekVaxHuztociIF27BlhFzL
	kvLQusCuainTS0DgUUX7r+EPOB9r2w+8O1yfYG9ToR5+5GhO2eCxnqw8RbzLmqKCVhuuXy
	lilkyB438qnb/+j7fpv0kU9lsjdN0f4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F49443F6C;
	Mon, 11 May 2026 21:49:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0B3C2BCF7;
	Mon, 11 May 2026 21:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778536141;
	bh=5BQmJOTGx+nxkOVS+Q328vEXsZt1I3F1c0weN13LzI0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tomABWcTQ+Dmg4owGcstqgU4YUjwi09Bbs70dlz6K3UI0YMmjEZfU6kvoCUTevWH1
	 IoAUvYEDhjPzVAoSY1nOMyIv90VheIE+9Ev/ApE8SDrftopozrm8fo3w1yMu1VeTVh
	 GkUK6poSC54kK5Af4IeUD4laYXOszE5S/WqL4V97Tgarf6WuMVWWWOTLpPe7Oe5cW8
	 MI0sP7eTE/pgKmAfRW0xthetmxmz++onEphOjANsSHauuQ+4dqzA18Rq9COnzDVjQQ
	 zycfnL7F3U8i0Y4ZiWKqZ3sVS9q/If2sqw9q5l9cPUeWv8s19CMnBSUiI9pSCEF51p
	 PBsdow1fR1WqQ==
Date: Mon, 11 May 2026 14:48:59 -0700
From: Minchan Kim <minchan@kernel.org>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, david@kernel.org, mhocko@suse.com,
	brauner@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v1 1/3] mm: process_mrelease: expedite clean file folio
 reclaim via mmu_gather
Message-ID: <agJOy1vnvYGipnku@google.com>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-2-minchan@kernel.org>
 <20260505145318.97692A14-agordeev@linux.ibm.com>
 <af5cEycgIu2GUicn@google.com>
 <d9644dab-120f-485c-9324-205282d89234-agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9644dab-120f-485c-9324-205282d89234-agordeev@linux.ibm.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 63ED81A000C
X-Rspam-User: 
X-Stat-Signature: gyky7fway8skffgtaf9y7xabitgyjpcc
X-HE-Tag: 1778536142-66800
X-HE-Meta: U2FsdGVkX1/5ZGK9wxXNfhm2NIjFpH0xAwkgCrSAlZhF/55XPbnQ3aE5Z2IsF35aRJ6oMMnO4UFVet+PrpPj+DOV3PRApjJkXJf0VAq9AuAW52qdXeX8uQis22VGFm/beaUYZ+Ftt1I5gRPZeXOpb34LxbYpe/fjVLHAYHFdJCyigW7yBuWThB7VIaO0tDQJPCLpBBGX2FHBMRisU3pJwNBYcyEn5QhoXO73+ryEqq1yej//P7w/6BfzOfm8xFc1ieP4XshLIAkGqE8TCh8viYO/82k3/Qa40oGGD1rOBuPTeGGm1c8ZcTaL78yh0pvyl2mhN3AUQJI6GiCvgwX4O7IvyvTE28cvA8tRYHdEmR2n8siEKbSU8W6JgSJM5JqA240Ozxinklyz7qRbKnaP1FVLexZoLmVzG7GwLR2gfvPf+Eej7wg0ggEP/lQb4mhWjhOgbNw7z6601xdkub6vVPFylWoL9KT756HCJ6fxhLVMA7NiHf0YqfpcwDWdt5sreFpxO+gqtHuQxI4nT1Mh7h+jMeTAdp0JcsxXInEpV0t46moeppbXMb3SxDDCdPbfgwW8tCb9UpovP6XjFoYNsrAqtHd7aARhYosAywZjQN2QLIFwloiuKM2wuhB7IKLrtA3H5H3fFL7yWXT4JbyngaZGw0Fa24EP5/W+DWq0HzpiICBzMIi70D/IP7Z1HP+5SyAm9Yrup6XWJxmzknJkIWMhmHmIucbSC47XmHSE/CTkk5k3Oz5jIRb7apsOfd5DMN/28oTz4z+HCqRSUhj/Lsn5AX2MYOiicpKbvctDLb5GelWswfdv7Urndi4MH4QL3FgrZ1h5oZ/LC+SwRS7TgUjRbNgv7fbS2LDRv90lFGbxrhwcFbAKPKuPQ3JjY0DCW7kNaE2HCygmuwZURv9yQE/qPl9w3Z2RKRbbl9IP1cgVL6ngn67CDg1jRKDgtE/YQDfWIx8whmkmqkteBAG
 L1hQO1gt
 gSvFgK9nX6lqgyy5etGtFv+P4pt8IEspw7J/eBiG1R5GdAtJnlqIojx2+AyEEB9xJHD2wX3IciOZMgRPU8PNuijRefb7cS8PKj2x3bEqXvB6+VLRgO4jzBdxXL17nmS26ZMF9Kng5pVcdhGXK/6BndVz121mvOs/hV9weZJXWHSyXfjbPPmtHmrgwTiIzk6GyaKI6K9nKEcsuh1mj25SpPhVKhUy+99zHz1p03Sl1EvoSol/ZqsvXQAhl2vo8vFbu54eMkl1WJdWvBjqW8h3MHLPOHQM9RZ459zYkcYB+x+q0sb0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 06:13:09PM +0200, Alexander Gordeev wrote:
> On Fri, May 08, 2026 at 02:56:35PM -0700, Minchan Kim wrote:
> 
> Hi Minchan,
> 
> > > > +void free_pages_and_caches(struct mm_struct *mm, struct encoded_page **pages, int nr)
> > > > +{
> > > > +	bool try_evict_file_folios = mm_flags_test(MMF_UNSTABLE, mm);
> > > > +	struct folio_batch folios;
> > > > +	unsigned int refs[PAGEVEC_SIZE];
> > > > +
> > > > +	folio_batch_init(&folios);
> > > > +	for (int i = 0; i < nr; i++) {
> > > > +		struct folio *folio = page_folio(encoded_page_ptr(pages[i]));
> > > > +
> > > > +		if (folio_test_anon(folio))
> > > > +			free_swap_cache(folio);
> > > > +		else if (unlikely(try_evict_file_folios))
> > > > +			free_file_cache(folio);
> > > 
> > > This condition is absent in free_pages_and_swap_cache().
> > > What would happen with non-anon and non-evict folio?
> > 
> > Are you asking about mlocked pages for file?
> > 
> > During unmapping, munlock_vma_folio() inside __folio_remove_rmap() clears
> > the PG_mlocked flag and moves the folio back to the evictable LRU list.
> > 
> > By the time the folios reach free_pages_and_caches(), if the folio is
> > exclusive, it will be successfully evicted. However, if the folio is shared,
> > mapping_evict_folio() detects it via the refcount check and skips the
> > eviction.
> > 
> > However, I realized we miss shmem folios in the swap cache due to the new
> > folio_test_anon() check we introduced. I will update the check to something
> > like this:
> > 
> > if (folio_test_swapcache(folio))
> >     free_swap_cache(folio);
> 
> This condition looks redundant, since free_swap_cache() checks it too.

What I meant is that the free_pages_and_swap_cache calls free_swap_cache
unconditionally for all those folio but my change in
free_pages_and_cached calls it only anon folio, which will miss shmem
cases.

