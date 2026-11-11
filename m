Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE70A606A331
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 18:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lUC4o3zt
Received: by kanga.kvack.org (Postfix)
	id 0D49D6B05B2; Wed, 11 Nov 2026 13:07:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 085A26B05B3; Wed, 11 Nov 2026 13:07:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB8AE6B05B5; Wed, 11 Nov 2026 13:07:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C26DF6B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:07:02 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D3E1D403C3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:07:01 +0000 (UTC)
X-FDA: 85423619442.16.42A4CC1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id BF25C1A000E
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:06:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lUC4o3zt;
	spf=pass (imf19.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794420419;
	b=5A5LP16VqqBEQaw6JJxfOsGyJ5EjFKd7OOKKBRWFMSFNmLrgOGhpwM5Oj2jiFLFuSx8WHT
	lE818U2ha5uvXUSDZftraKX58Slj7iH7uGptqHJD4Eg8UtthgvCJhWvPcHuaN5rocY/VAq
	M/eI2iObUr/Nm95161mXemS/3TcN1YE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lUC4o3zt;
	spf=pass (imf19.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794420419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PEoVa1/ve/PN9rU0jpGakgmZs+XQWXgtWWpspfzoeOQ=;
	b=SyTKQj5pd8qn1LVjOelP3A1HZCtUEA2k1E20GtZ2f5kDt4Nixnhrx0f/C2xFUnZP57U7Xk
	h2tFSaNReMMgQkAhVUymdi9vIDUKicaPYcuUxzGTBWHl6MqyhsHbI2iof2DL6qIGgpPmib
	v6xufw27H7abiO9vNRpTe7eA8/Xg540=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 251B1474C2;
	Wed, 11 Nov 2026 18:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AFD1F00A08;
	Wed, 11 Nov 2026 18:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794420418;
	bh=PEoVa1/ve/PN9rU0jpGakgmZs+XQWXgtWWpspfzoeOQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lUC4o3ztvMwDMTLneXRLpy6WWE3mY9EEsCqHoCSZuUj4x1a7h/9U1dAGFlMWySg1B
	 cy+3JWu77T8HFf/LNI2QKBAyX5ubu4Jx9buZwsy9fGjGxARjPgaKjOl6wQ2NLG/0u1
	 NdkrbaCkbQtFebjrfWlX1uwxlfs6Bfdwi+WNJ2xa2MDceyUkN6/IL+wWAVmi3IlAH/
	 a3qEabhmWybC+TnjABqTkRNnkWph+tWY7f6OU8K0UoDWaxObMr7saOeycToRNP6ajq
	 1q1oaSxUcgGBTpJUlpp2X0auGjKMoKuu8HqZE1s3Ng51Kwtrq9buvum0Sw3o4SC1ee
	 NwzlocaDdnuLQ==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.ams.internal (Postfix) with ESMTP id 92DD8198003A;
	Wed, 11 Nov 2026 13:06:51 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Wed, 11 Nov 2026 13:06:55 -0500
X-ME-Sender: <xms:u670aiPLTfCAfgZIYntvEFbTMpwZxAF4T1hLI1RIByc7ytjGjAXc9g>
    <xme:u670aqLFoQXp6tw3P4MZF4tje30lkbKjNJNOhXPkL13isE14DyxPlVQC7wA_b6gL1
    Ytc16JiYQycQnRc1Hzsc88_ycWQxN4e-pG6-SmjIUGooJF1nkXSWzE7>
X-ME-Received: <xmr:u670atjktQdNqe3B6L7K26wMbQYdMJB9IgGenRjkHGwfHXRrxjQzXuraL-0>
X-ME-Proxy-Cause: dmFkZTFqGEOXfSfkLafJsQr9Y62vpFZ8gczs/OMO8l2OK4dbyp0m817ffGPPnJL/BoBYUc
    3axE/I+kzJ7xDpg6TNdrBkPI2fuEsYhMyEySmdM6mMIpTh2eTQUUYQS7Q2aMjaUi2l0e/s
    YpAka7C32er73aX6XqPDLKcxBd6ntQ3lGOVRwDlH5wQ446IgLTTwlqgZjA34De0W42iKCm
    miusSXuGyPd1MqjWhBbPQj8SWNLRzJNiJnf+YUwDmgUZIyHYJBPibdJ4snoguGJLtJy8X+
    FiSLqI+l1jSSG+oEjrIchXRim94s/+wFrZPzvl3wTGdof/NlcafJ/j8EgfQqQsCOHbIBU+
    mJ3vjECPrabMFb6vt5aw15o0AEpABNB/+GEKG8XrQKLknTAeia68QT5qPyvAFh5pmFuiJJ
    GI4eTllCmkCZ2ZU1w+DfOspIhtEEUpUw3dcHLl6k/DVgCwbatWG/Buy+K1yjIlH5Ne3Km6
    +ANYAdJ/W9tF6qhxuy3dCwYspoGYH2YjR1SrbD0OmB3ahNDVZbH22y2u9gBmXILAQns+26
    A7jOZuEBf3vKw7bZpMrGdDmKUeH2wY4FMg3R94ortdxxwDxBJaCXnl9YGpxdGYrElovmZd
    uIPdXYPX1uETlFAamiSd9TDf+46RhYC/9mFwjbScoUsggPz99oWUtoBM5mnA
X-ME-Proxy: <xmx:u670aoeClApmTzczlHgeUVl7j4D2d0wbJjYc489Frr68-4joJvMPwQ>
    <xmx:u670al4UJCN0KVoFyijJWCN1KDKthtCXHROrwhbeCL7JaqcYmAGS3Q>
    <xmx:u670ahgUARxxeT_wKjb7j8oW59Bo2rKnuo24DqFu25C7HrCOaIlY9g>
    <xmx:u670asGtXX-EhtPLMO-6ChxBXh9ZzJJ0qpz9P60pIDT9SNusYi6HxA>
    <xmx:u670akXCc3HiQJGZHOORGx0sjgtXll6D_SuQ8-15tgxSr6s-CMfdz_Nb>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Nov 2026 13:06:50 -0500 (EST)
Date: Wed, 11 Nov 2026 18:06:49 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Ye Liu <ye.liu@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4] mm/huge_memory: prevent losing PG_waiters in
 __split_folio_to_order()
Message-ID: <avSupujJqz18VDva@thinkstation>
References: <20261110-fix-split_folio_to_order-race-v4-1-cc5042f33408@nvidia.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-fix-split_folio_to_order-race-v4-1-cc5042f33408@nvidia.com>
X-Stat-Signature: h5gqr8fwaud6ob8s9fqitzu139dp3o8s
X-Rspamd-Queue-Id: BF25C1A000E
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794420419-942056
X-HE-Meta: U2FsdGVkX19d1+UMnUU9qDhNe18SexEatTYsuLIPKrIxbOIDUj0o1SvpyLUUYXOhS9p96J4cCYiuSW1IwNJfu0feW4y7hsyJcH4/JGax1B7fpY5UqZyF7K1iY+8woHlft2IksNeD2oc8S1qs3RvU4ImXfRp0yZs9S/sjEpf2O8+pWBJOwm0ALAXJZxRtwVQxSakuZSIuiSMURpIcKScDkD+b0GDoA5s+yLgHWraEHZsySowBKelUlLegLFgzwditeSv7kajjzyWoB1ZDYGTc0Bqwr+02gx4C5ve5yrcSqQRyCm7pGSgdjNPthZa8sWr0P+CqvllCyjvPnSDc9llEEsHbmyWF4NnnXIA56YFbArgBC793GoXQ66so4ElMSPAskqOJObhcM31ssTaSrRbLEiBx+OuQWzsErB7cMj0G461xmSieIDxFpS7J1k4RhuoKgxs5A8E1oFNvOcYvj+Z+v6KUHVgFbvYYRw4R3eHL7vGgIn15YsL3X/oF5zTR+LliQxTlzJNm/8PYqAYcYG6eFy+4JsMjqCOsHb8eDzhtm/crCU0k80Ompe3LcM46vY0WvtLy60mSKqw01wTRCB9dLclCBZaz9joXd5mhaQmFdCPjAcAZ1sRLgwKitA3dwDisPExeQYXtrVnICWvEv+lNOxbX7tRxtBs0IcOazv/GI17FglFjn40wBBbyUFAcNiMw2q0nIr8ukDP72Wr2O0KXVcybJLxJs1pMHVvRfGOUhM1IEped26zniv/hFEPBLNpU8RxLGg8rMwEOslxXYwgMw7EjgozrRi+VRBnALnjXIzONZEDAYbYmpFJVaMgLLIKfymOj8BWyhoT/irXxvncJksr/22hrd94rLlxs2tuMXK25/1Q/kycFA7UltaAlbVnZekyY9ecaDpR2xQXnCgKHGQB6MyPa5qpnkDFi4ziYcIzmYfpfI/wq9e08fCOCpot3EXdJBJhR5zzb+KRF+n2
 oyWA1VuJ
 +EOFFNxM/EJs7bqGP44WVIhY2/77F/XZRqg48DXTZJG9bTSFOAs7lB4/LyVxLsvfG+MCiNHPgY1rIgEVtdVAbXg/HzIcw/OgPkzgR7hg60dmEKYcbqK8XA+tMsfM10Uy6nrxyXMiDzkY0fIS5C/CtNl6+1dCShUgQ9pl8bDqvdZjVIolOgKHCGFb3LGZi0SDsRc92ju0SVx9ed/io+RWAaaQajI12iXvhYx7Xz+8pfoWe/6fYNv53WH+3OtpQNzQxr+0qdUjjuA7TP2h5GvfTEYQJ1SG4gJNKUaI7LnB3UltCi8d1XQLBR1oYiTj6tdXeHQUR3mCvZKiRZ55G8m94mtgSHlQ2pSbm80cYTp5im53AsqtVSvg81HmyAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 10:19:25PM -0500, Zi Yan wrote:
> __split_folio_to_order() calls prep_compound_page() on each new head page
> to create a compound page after clear_compound_head(). prep_compound_page()
> uses non atomic __SetPageHead(). It is mostly OK, since the folio is locked
> and frozen and no one else is supposed to modify the folio's flags.
> 
> However, code calling migration_entry_wait() can reach the folio by PFN,
> then access its flags. It is because softleaf_entry_wait_on_locked() used
> by migration_entry_wait() sets PG_waiters concurrently without taking a
> reference and the frozen refcount during split cannot block it. Meanwhile,
> __SetPageHead() does a plain read and write, so PG_waiters atomically set
> by softleaf_entry_wait_on_locked() will be lost if the set happens after
> __SetPageHead()'s read and before its write.
> 
> One example code interleaving:
> 
> CPU0: __split_folio_to_order(new_order>0)  CPU1: do_swap_page()
> 
> 1. clear_compound_head(new_head)
>    new_head->compound_info = 0
>    (page_folio(new_head) == new_head now)
> 
>                                            2. migration_entry_wait()
>                                              softleaf_to_folio(entry)
>                                              page_folio() -> new_head
>                                              (not the old head any more)
> 
> 3. prep_compound_page(new_head, new_order)
>      __SetPageHead(new_head)
>        tmp = new_head->flags.f  <-- load; PG_waiters == 0 in tmp
> 
>                                            4. folio_set_waiters(new_head)
>                                              set_bit(PG_waiters, &flags.f)
>                                              enqueue on waitqueue, sleep
> 
> 5.     new_head->flags.f = tmp | (1UL << PG_head)
>        <-- store; overwrites step 4, PG_waiters == 0 again
> 
> Later, folio_unlock(new_folio) sees no PG_waiters, skips folio_wake_bit(),
> and CPU1 can remain blocked indefinitely.
> 
> Fix it by setting PG_head along with other flags in new_folio->flags before
> smp_wmb() and clear_compound_head(). The remaining compound page metadata
> is set after clear_compound_head(). In that way, after
> clear_compound_head() makes new_folio visible, nothing overwrites the
> PG_waiters from softleaf_entry_wait_on_locked() by modifying
> new_folio->flags non-atomically.
> 
> While at it, use data_race() to suppress the KCSAN issue reported by Ye
> Liu's patch (the second Closes) on reading folio->flags in
> __split_folio_to_order().
> 
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Reported-by: David Hildenbrand <david@kernel.org>
> Closes: https://lore.kernel.org/all/DMHE8BEEER1H.2BIY52NXATPIA@nvidia.com/
> Reported-by: Ye Liu <ye.liu@linux.dev>
> Closes: https://lore.kernel.org/all/20261029-data_race_huge_mem-v1-1-112e331291c1@linux.dev/
> Fixes: c010d47f107f6 ("mm: thp: split huge page to any lower order pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

