Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F893CDE000
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 12:07:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27CA36B00B5; Thu, 25 Jun 2026 08:07:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22CB46B00B6; Thu, 25 Jun 2026 08:07:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11C6C6B00B8; Thu, 25 Jun 2026 08:07:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DEE4D6B00B5
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:07:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 626661A05D8
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:07:45 +0000 (UTC)
X-FDA: 84918310890.12.CB4AA2A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id BA1ACC0016
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:07:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KDZmqBG2;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782389263;
	b=NSHJ0PjNxvm5MVUXmB+x7GEOYbRarC1epbsQYFuyScfI5vAAzl7JwwV0OLWElvHNenqEz4
	kRTNr7dWKkhlFVfJai/FIqV+rw3LpczO2CDwktl135TbqsZ4y7lwq3P4o5Vfh9X0fpvMHN
	oQ9fwrZwLlyvKIc4C3vkjl1nFRAs6so=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782389263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hzOWIM48785YXF4+EkAFQi3dSVtrixHEzc/TOh6UnkM=;
	b=zSipqhUNGPPBbY3UeBXuogqVt5q2x5hS9XfKvHKmbGr5v8xUJ2PNt47p6jreImSUukcOPo
	xuT6Km8kclmvrgDttEM4BNPGDlDg5bgCv8OirsE2FrVne4Pz4xQz60ff1ROnSCHDMn0+nd
	8LBBYYmESN5RX6fdiVGNs0luzIhL5hc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KDZmqBG2;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 50B24600C3;
	Thu, 25 Jun 2026 12:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B0D1F000E9;
	Thu, 25 Jun 2026 12:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782389263;
	bh=hzOWIM48785YXF4+EkAFQi3dSVtrixHEzc/TOh6UnkM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KDZmqBG2siXwFLEI6Sm2qljEbRdd2HnaDa1c+SIy7VYes8nW+jYo4yiomKt9moDpu
	 HHnqrswZpDGY9vW1YmPtGYEparelZcqK79bL1AJCcjKe340mRooWJZM0hNAv0w1rxZ
	 5vRimF0BM88IfJ7VPpu/lAXjVLtg3kcqGzP3hYc9NTFFo3ai4ddM+SPQmJdUJgiaK6
	 KcQ0uwfATmwgG2FEI97wtBkEk3idv5jozP4m8O+ymKllZ+rYTRXU3YCe5EpcSKfRHX
	 xvbAhwRTHnpac978/L40OsZt8ePDZTedhfnXLHVdpackdCvohA2WeX1r3t3lzJ0dIT
	 qOFrpXnyWiZcQ==
Date: Thu, 25 Jun 2026 13:07:33 +0100
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
Message-ID: <aj0YlpCkGySxt7-D@lucifer>
References: <20260625071830.996043-1-hui.zhu@linux.dev>
 <2c4dd46a-4755-4bf5-8f14-2d73eb356e3e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c4dd46a-4755-4bf5-8f14-2d73eb356e3e@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BA1ACC0016
X-Stat-Signature: guz8mhobzshzgk1wwkqhyaugc4dm1rte
X-HE-Tag: 1782389263-13438
X-HE-Meta: U2FsdGVkX1+lB13faHVqRrpqbhZqCV219dCPsLZHY0LNdydBVANBB6JgbBUaXr48wV3ofa+3jCIBBU1PjBW4hVauoMV8L3iMFDFJirEZsnr+0fY5MaimivAvewoc464PS2GVVPohRJ+RtB8NhuTh1gvGSkimkMSKgNk7fVLtAb6OEaPYKrj6JSZ+2jtl66QJHxUXRsQ2rZABkmLX/XKQWns0HNuiGShtVwrrhB5JS54gLjxlibgeoPDBoXqGSK8O85D4WesNjMRYSckq4aI4jfY3i7zS5vPScFyR/+2jFmY7/WzRSOSTrLTxQQ0Ui06wLXh7SLJMB/R/i7dFyGVTs5c9/IgYOz10iQ+RDCxWQFV5+1ujZ4Go74sEr80wW0iaySKMjT/GSB2tjwQ8vr3rIuw4B48K0N7nPt26ZL+0yD0jIltoyGyHF25pbUFSHXNPv9wqnecGYLS/XIZhPfjKv7TkK6pLR9JvUsmPjwBDUPH1roB++YmJIe39FRAOx2Z1CkYf6fLQ8oIcsVn3tuSJa4pf5LBiPh1hgzDCaEwcoQVX/W+DNOLtkKQ6hsE7S9YI6HrIR0fbXNtZ2uQYgC+ukzmwW+OnRrn9MSsja8xzHMS+iqp4JRL29mk2iqsGs8aGiduJ1a1sEaWaHUmZzNmKDfqmeCjf7BT0oEM3qGRE7g76LKfe+CF3XB87NcGtaDWH6bmjmUcUMKmhtlqNV1ywFI7gV/Z8C7PGHpdIS74a3e7O8dUuFmW32Ap/kZ4GxTziYVEFzkpUQ7glMyVVnTk7y5luPJfwy2aSj/QMyX4r3TBZHEv76pnr0HaCQ8YMQDw+uqdK88evSJ4pAyoV34pKfRUQXP3Xo5m73CinzvG/NxaTir/8ThFXDdcZJ8b9XXTbcyIadAGxeoJLP5VJybMoa691MwaKh8Nd3EjLUHKbTNw+yO6N9TJCKIz8be6k5vm+OEb7N6M7c26bIExHaZf
 CWz159qX
 a1or8Hm6t51PtG1EpT3lah6LSrt8/yUSikP2TR9zioFqaY9xOhzV/cqnFgG68rRyWjASqSovZNlw4ujjPg5bApz6dRyM3sJ4pfnlc0PDIHp7SUqdJkLBPI03HMrYw9t4kbdxRKwU0G9yPLjlxLZwlroXbmIQa8xD+9yEmMjBOHLhkn/auf2N1SLbCW4kRMKzbqFkO7R/oteZNy5AaJA7eNd2uIKJCvntWhBb9VV9oiEfNYVFsmdBu03PjDJ8+TpdXZKDddga8oiSMdCzorQPU95Zr1pJ2fzevL9MgxwpvVmkw7VXcdlko3Wz9qpDO9ERJzhma90EslZnO0gA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 01:53:14PM +0200, David Hildenbrand (Arm) wrote:
> On 6/25/26 09:18, Hui Zhu wrote:
> > From: Hui Zhu <zhuhui@kylinos.cn>
> >
> > KCSAN reports a data race between page_to_nid()/folio_pgdat() reading
> > page->flags and folio_trylock()/folio_lock() concurrently doing
> > test_and_set_bit_lock(PG_locked, ...) on the same word, e.g.:
> >
> >   BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio_gfp
> >
> > The node id and zone id occupy fixed bit-ranges of page->flags that
> > are set once at page init and never modified afterwards, so they can
> > never overlap with the low PG_locked/PG_waiters bits touched by the
> > folio lock path.
> >
> > ASSERT_EXCLUSIVE_BITS(mdf.f, ...) inside memdesc_nid()/memdesc_zonenum()
> > checks a by-value copy of the flags word, not the actual shared
> > page->flags/folio->flags being modified concurrently, so it doesn't
> > reliably assert anything about the real race. Move the assertion to
> > page_to_nid(), folio_nid(), page_zonenum() and folio_zonenum(), where
> > flags is dereferenced directly from the page/folio.
> >
> > On CONFIG_NUMA=n, NODES_MASK is 0 and the old memdesc_nid() body
> > folded to a constant, so page->flags/folio->flags was never actually
> > read. ASSERT_EXCLUSIVE_BITS() is a real runtime check that can't be
> > folded away, so doing it unconditionally would add a pointless read
> > of page->flags/folio->flags and a check that can never fire. Keep
> > page_to_nid()/folio_nid() as plain "return 0" static inline stubs
> > under CONFIG_NUMA=n instead.
> >
> > Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > ---
> > Changelog:
> > v5:
> > According to the comments of Sashiko, guard the ASSERT_EXCLUSIVE_BITS()
> > calls with #ifndef NODE_NOT_IN_PAGE_FLAGS (for nid) and #if
> > ZONES_WIDTH != 0 (for zonenum).
> > According to the comments of David, avoid calling
> > PF_POISONED_CHECK(page) twice in page_to_nid().
> > According to the warning of lkp, switch the CONFIG_NUMA=n
> > page_to_nid()/folio_nid() stubs from macros to static inline functions.
> > v4:
> > According to the comments of Andrew and Sashiko, set
> > page_to_nid()/folio_nid() as static inline stubs returning 0
> > under CONFIG_NUMA=n.
> > v3:
> > According to the comments of Andrew and Sashiko, move
> > ASSERT_EXCLUSIVE_BITS out of memdesc_nid()/memdesc_zonenum()
> > into the page/folio call sites.
> > v2:
> > According to the comments of David, remove useless comments and use
> > ASSERT_EXCLUSIVE_BITS() in memdesc_nid() instead of data_race() in
> > page_to_nid().
> >
> >  include/linux/mm.h     | 23 ++++++++++++++++++++++-
> >  include/linux/mmzone.h |  7 ++++++-
> >  2 files changed, 28 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 485df9c2dbdd..772bd1fc6fe7 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -2294,15 +2294,36 @@ static inline int memdesc_nid(memdesc_flags_t mdf)
> >  }
> >  #endif
> >
> > +#ifdef CONFIG_NUMA
> >  static inline int page_to_nid(const struct page *page)
> >  {
> > -	return memdesc_nid(PF_POISONED_CHECK(page)->flags);
> > +	const struct page *p = PF_POISONED_CHECK(page);
> > +
> > +#ifndef NODE_NOT_IN_PAGE_FLAGS
> > +	ASSERT_EXCLUSIVE_BITS(p->flags, NODES_MASK << NODES_PGSHIFT);
> > +#endif
> > +	return memdesc_nid(p->flags);
> >  }
> >
> >  static inline int folio_nid(const struct folio *folio)
> >  {
> > +#ifndef NODE_NOT_IN_PAGE_FLAGS
> > +	ASSERT_EXCLUSIVE_BITS(folio->flags,
> > +			      NODES_MASK << NODES_PGSHIFT);
> > +#endif47
>
> This is getting ugly, really. We're leaking implementation details from
> memdesc_nid() into folio_nid().
>
> Maybe just turn memdesc_nid() into a macro where we can just do that check
> internally? Not the best thing in this world, but better than this here.

Could also do:

	if (!IS_ENABLED(NODE_NOT_IN_PAGE_FLAGS))
		ASSERT_EXCLUSIVE_BITS(folio->flags,
			      NODES_MASK << NODES_PGSHIFT);

But not sure if it's that much better.

(There's precedent for that form of it in mm/numa_memblks.c)

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

