Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E40ECC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 10:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBCAA6B0005; Mon, 29 Jun 2026 06:26:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D944A6B0088; Mon, 29 Jun 2026 06:26:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD1816B008A; Mon, 29 Jun 2026 06:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AEA456B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:26:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3392C4063E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:26:57 +0000 (UTC)
X-FDA: 84932572074.03.B4E19EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9D24512000A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:26:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S9QscAoC;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782728815;
	b=QgF357AyyIIMtTVX3SWVO6o2LwzyqV2c1jIMBJKJZqNDOnDlvocRs/p22bNNfnGWlupARt
	yX6l7eikrNJ1+O/SZh5aMFzjp0GweJZ+vMkz4BDLGI/Z+Dr4daaZJgwv+DKeR1EjClAtKx
	5bimveXfkNj3NAgUINcojNsTeQybEkg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782728815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sCpWp+WP18a51W0Wds2yLSSvymsUKmeoRVPKKR/GJMo=;
	b=oMtPTsSw1sOJNJLmC8t7K+b4X6u8HSF1KrexkBEmGzrucSuh9McG7aotitBzi34VslYwhe
	v5xpk3jCCGIYX5bIP8UQRVQG82v4ZuYdBp3ccdFkCovfNWcZMIGsNsWnb/Ljk5mlbeKI1K
	tQRfat2oFmuvS2id4aW2lnYZeW40mdY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S9QscAoC;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 21A7660008;
	Mon, 29 Jun 2026 10:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96C01F000E9;
	Mon, 29 Jun 2026 10:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782728814;
	bh=sCpWp+WP18a51W0Wds2yLSSvymsUKmeoRVPKKR/GJMo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S9QscAoC5Ej/+BLfSY8duB/nQtuinHR2xPD7Xgb/YeVsinPZihIvVCLkjFKZ4NGiR
	 vgbcVGHETJgafBzt1aqIyWGJa3AbheTOXA77+Gsvck0PbXFaSSM81j93W2QkEXL13Z
	 ziS9ThTsTlgxnxp5yyi6fvcXua6U37FGcLBQRzB5xi7TvFcWew0ykN3j6vcQTT41ea
	 5d0ynRFR5buOX0RZ5F1pmei717y/09wbkb1BZ+riIERZmXsmt8oZiQ5xmVfsGC9iKJ
	 UJP4299OqZ346RPe1e77LN6x5pzN+ium8+mgzmDtxaLlGPUekoof8PHW+jt8J5XjdD
	 71NNZBZwKLU1A==
Date: Mon, 29 Jun 2026 11:26:44 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH v5] mm: assert exclusive nid/zonenum bits at the
 page/folio access sites
Message-ID: <akJIURsxzZ5TwEp0@lucifer>
References: <20260625071830.996043-1-hui.zhu@linux.dev>
 <2c4dd46a-4755-4bf5-8f14-2d73eb356e3e@kernel.org>
 <aj0YlpCkGySxt7-D@lucifer>
 <7efb57b0-7205-440c-8638-2ec5354aacce@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7efb57b0-7205-440c-8638-2ec5354aacce@kernel.org>
X-Stat-Signature: ojhdmu6jk3c1zezuaz9iyogdxuu749hc
X-Rspamd-Queue-Id: 9D24512000A
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782728815-107595
X-HE-Meta: U2FsdGVkX19UVkPmjYuvBDVFYZWwFylcdj0ejoz03X2RCcQpjO0MVvjJL3nO102EZ6ro3+zMO//trc6BKp4Ckh9KPGKjH0/l7i9X2KvOvVI946b5ADwX0GUMh0KMbimwCFN/VFP9HZLQCKYcs9ecsQaIeu6jftndaVZ2m9n3bkQhbZxVRA6Ywve2jcCRBN279pl8wVTm1AoxXoUN4gYjJLDp62BnCd47NfyxPP/qrfBU3Lm3RoyGWKNnH7p7KNjcdFW9HOy2ob1cR+i7zKWFgGKBVrfY67gmmLAMM/EX2FONPtiDQ18KVNo4coBc1EZswzrEvOxBxMggDc1m7O+cMPIYxa073JXVCyrcO3utLIc86xcf3j9Jd2h94RGZGHmveKZrFMBbuA3RSuT9uEoZGvJNYjbDiTXIloCEMxPvcnjj+TC85w/H/hiKCIpHmdDxmsPtx9J8IN6vLm7+Cjo/t5uBQ+Xi6MxGb11RyP3yGu4s+Lu5SZfdjpmvZNXBvLgTlSHKzZGNblO1cgeOnH4rtNEp+81nYGqZMItz9jq7BMOjx0uSYJEZEi2Bwq11cziyTszvk/Kt+zmxzVK/N+DGKDSzQa+xoPtDZF6tv8PB9kNaJgTAa3mcX6EN0ubRvD3LOXRBUeGdsdc05/UU/5wWwVB1JOfByhZ+jCACPdBpdwWpzxCK4Mqe53ZCEdBYhgsxL8tKWuUZL8WJIJD5Uj79GMQSs6/KL69CAKteaRfxJlKY8p1/8iWH5DgzjenbjlNArKnXsDVaw2xUM1Izo+NI0uYkVlS15i1I2ZamUcL4NNMAAhKnc5PBpMrH33Pesh3PaDqCmBFlr72s6X11z3pNaSFSeGKrnIvHfhdN4axeiGi0EqdK8XUkcDWWEI2TOfXTh16op+Rd/aa4TqAvQVBdwniagylfzvgrjNyeBYnb3zPy6O+2Asuaa2CtLeWRQ/h5CHvCrz4GUx/ugvWHlTO
 waf8Ndve
 vXA0rvd6nu09cixEmDe74hvVzNNdtUwcQFSap90Gz5x1xt0TnEzM2IM+6XEAwOYh+0OWjxkORavQos8B9wFi54AmLYaqAbwrCb3pAP7Lc3K9d5RJBNF+yz7/ZKwKRWY/SaDj4zUZxAK2f24a/ZfdLhzqhhdN4ptN1yDGMWEqzfCZTMrie+93Z8GKffaqKegDYxkYkVhFxYVZfI7IdVDkG1EayxMzyuhqgA/EpS4faZIqrW64WYgO5HrznV4q5aMLAaEs01SW3F/jKr8v7+RX5Q2JjYFvYlaSmRsteZ79rfK6pW9zs0E54uYBP0jxtkhAwdpZefMcx5/eHmgo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 02:08:39PM +0200, David Hildenbrand (Arm) wrote:
> On 6/25/26 14:07, Lorenzo Stoakes wrote:
> > On Thu, Jun 25, 2026 at 01:53:14PM +0200, David Hildenbrand (Arm) wrote:
> >> On 6/25/26 09:18, Hui Zhu wrote:
> >>> From: Hui Zhu <zhuhui@kylinos.cn>
> >>>
> >>> KCSAN reports a data race between page_to_nid()/folio_pgdat() reading
> >>> page->flags and folio_trylock()/folio_lock() concurrently doing
> >>> test_and_set_bit_lock(PG_locked, ...) on the same word, e.g.:
> >>>
> >>>   BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio_gfp
> >>>
> >>> The node id and zone id occupy fixed bit-ranges of page->flags that
> >>> are set once at page init and never modified afterwards, so they can
> >>> never overlap with the low PG_locked/PG_waiters bits touched by the
> >>> folio lock path.
> >>>
> >>> ASSERT_EXCLUSIVE_BITS(mdf.f, ...) inside memdesc_nid()/memdesc_zonenum()
> >>> checks a by-value copy of the flags word, not the actual shared
> >>> page->flags/folio->flags being modified concurrently, so it doesn't
> >>> reliably assert anything about the real race. Move the assertion to
> >>> page_to_nid(), folio_nid(), page_zonenum() and folio_zonenum(), where
> >>> flags is dereferenced directly from the page/folio.
> >>>
> >>> On CONFIG_NUMA=n, NODES_MASK is 0 and the old memdesc_nid() body
> >>> folded to a constant, so page->flags/folio->flags was never actually
> >>> read. ASSERT_EXCLUSIVE_BITS() is a real runtime check that can't be
> >>> folded away, so doing it unconditionally would add a pointless read
> >>> of page->flags/folio->flags and a check that can never fire. Keep
> >>> page_to_nid()/folio_nid() as plain "return 0" static inline stubs
> >>> under CONFIG_NUMA=n instead.
> >>>
> >>> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> >>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> >>> ---
> >>> Changelog:
> >>> v5:
> >>> According to the comments of Sashiko, guard the ASSERT_EXCLUSIVE_BITS()
> >>> calls with #ifndef NODE_NOT_IN_PAGE_FLAGS (for nid) and #if
> >>> ZONES_WIDTH != 0 (for zonenum).
> >>> According to the comments of David, avoid calling
> >>> PF_POISONED_CHECK(page) twice in page_to_nid().
> >>> According to the warning of lkp, switch the CONFIG_NUMA=n
> >>> page_to_nid()/folio_nid() stubs from macros to static inline functions.
> >>> v4:
> >>> According to the comments of Andrew and Sashiko, set
> >>> page_to_nid()/folio_nid() as static inline stubs returning 0
> >>> under CONFIG_NUMA=n.
> >>> v3:
> >>> According to the comments of Andrew and Sashiko, move
> >>> ASSERT_EXCLUSIVE_BITS out of memdesc_nid()/memdesc_zonenum()
> >>> into the page/folio call sites.
> >>> v2:
> >>> According to the comments of David, remove useless comments and use
> >>> ASSERT_EXCLUSIVE_BITS() in memdesc_nid() instead of data_race() in
> >>> page_to_nid().
> >>>
> >>>  include/linux/mm.h     | 23 ++++++++++++++++++++++-
> >>>  include/linux/mmzone.h |  7 ++++++-
> >>>  2 files changed, 28 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/include/linux/mm.h b/include/linux/mm.h
> >>> index 485df9c2dbdd..772bd1fc6fe7 100644
> >>> --- a/include/linux/mm.h
> >>> +++ b/include/linux/mm.h
> >>> @@ -2294,15 +2294,36 @@ static inline int memdesc_nid(memdesc_flags_t mdf)
> >>>  }
> >>>  #endif
> >>>
> >>> +#ifdef CONFIG_NUMA
> >>>  static inline int page_to_nid(const struct page *page)
> >>>  {
> >>> -	return memdesc_nid(PF_POISONED_CHECK(page)->flags);
> >>> +	const struct page *p = PF_POISONED_CHECK(page);
> >>> +
> >>> +#ifndef NODE_NOT_IN_PAGE_FLAGS
> >>> +	ASSERT_EXCLUSIVE_BITS(p->flags, NODES_MASK << NODES_PGSHIFT);
> >>> +#endif
> >>> +	return memdesc_nid(p->flags);
> >>>  }
> >>>
> >>>  static inline int folio_nid(const struct folio *folio)
> >>>  {
> >>> +#ifndef NODE_NOT_IN_PAGE_FLAGS
> >>> +	ASSERT_EXCLUSIVE_BITS(folio->flags,
> >>> +			      NODES_MASK << NODES_PGSHIFT);
> >>> +#endif47
> >>
> >> This is getting ugly, really. We're leaking implementation details from
> >> memdesc_nid() into folio_nid().
> >>
> >> Maybe just turn memdesc_nid() into a macro where we can just do that check
> >> internally? Not the best thing in this world, but better than this here.
> >
> > Could also do:
> >
> > 	if (!IS_ENABLED(NODE_NOT_IN_PAGE_FLAGS))
> > 		ASSERT_EXCLUSIVE_BITS(folio->flags,
> > 			      NODES_MASK << NODES_PGSHIFT);
> >
> > But not sure if it's that much better.
>
> It's still making an assumption of what the memdesc function we're calling will do.

Ack, yeah we should avoid having implicit assumptions as to use here!

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

