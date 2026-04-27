Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13D7EFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 13:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41BA86B008A; Mon, 27 Apr 2026 09:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CC906B008C; Mon, 27 Apr 2026 09:00:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E2AF6B0092; Mon, 27 Apr 2026 09:00:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20C786B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:00:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3E9E88DAD
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:00:46 +0000 (UTC)
X-FDA: 84704345292.10.DC70F6F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id D7D95C0009
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:00:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KhresZp9;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777294844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3pPbjszTa9FPZHzEBxBvM5QTIp8aOy3rtQ8mmz6pcLE=;
	b=3Hg5HFznjcS9qEVdJCSoljHgmfirdHsgwezJJ6DMUZzQqrGFLpfePgUmA/xruPE9iTIrYr
	HcVJf9g68bHiF9pkQtg6myGPw6fURsJ62TB+ZTv4bLfaM+fC5zU8Uwl9hi4a8bKdmSGBvl
	mfgHLsrx5pkuxORNMiH10zeSOv2Vmec=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777294844; a=rsa-sha256;
	cv=none;
	b=eRR4SnT3HUJoY3a0qkoZ8Gpow4LvlJfw1D2UYqAvOmLTLGwdiKTQaPKo/rJBp21v3FPN+X
	NHS8OJ5yTbXL+Um1RnJJEtSfD8IgBiZpcp4HaeE2uEbVw4eH5WRG34ePscJf31boBf96v/
	MgDbz7KYbeHyGI8WjK+mLpY33Pz5wQg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KhresZp9;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3pPbjszTa9FPZHzEBxBvM5QTIp8aOy3rtQ8mmz6pcLE=; b=KhresZp9qVD0MIn2zcL6d93p+u
	YP6E0DDNIPcfHMGbSJQeuyCSK1cj50OfRjVJARZtOM8LmCEUABm8jKVR923RuCzGDTYSBnzn7JByk
	2HUBHnab8NCjgQi+8wTrjmCKIWQGfOqoyzc8ND874Z8uwqSGXy/nKlM1Cdcg/IeQpVHmmpxvDZvr8
	IjJeWL9Z5BEJiGYWJNHnAu31LR6HjEC6evr5wOtENKrU9sKOPiSws7F6cpkIks6ZMYeVp9DusSyeO
	27l2WRHnwk/V110p/IysON5iyNnX6M8KN9wujEeKBVN7/tpdN7RhNiuXYhUEdUu7Bd6Wg9YUs8+WN
	rwLE6f2Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wHLZi-0000000263n-3frl;
	Mon, 27 Apr 2026 13:00:34 +0000
Date: Mon, 27 Apr 2026 14:00:34 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
	"Liam R. Howlett" <liam@infradead.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/3] bpf: arena: use page_ref_count() instead of
 page_mapped() in arena_free_pages()
Message-ID: <ae9d8rXC-V2OkTcf@casper.infradead.org>
References: <20260427-page_mapped-v1-0-e89c3592c74c@kernel.org>
 <20260427-page_mapped-v1-2-e89c3592c74c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427-page_mapped-v1-2-e89c3592c74c@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D7D95C0009
X-Rspam-User: 
X-Stat-Signature: upc9yo46aoff9knufgqf1gqjesxdzrmw
X-HE-Tag: 1777294844-144849
X-HE-Meta: U2FsdGVkX1+PgICpmF4gmELBT/+n/iipnZbtJFIPO1TUVhAzEoVzxXBUb9xtXDPknQWsIuvc74yRui6kHqWcD8czLS2KwU7zJMSP3aM5DCaMJo/vs3kOhZDKEcIZd39fShWR+Xr+3VPmfdvvJBs2rak3ARn57ZjX3L+DR+eS0qSRmxs2+I9SOfYkaav7Cw8bV3NC9K/GxQsQvZZD7TYSxVESkjLw3JL2U2d9wkdA/K/wX6/YvfheJ8ZKm3+1ZJNmEhiRM4Mktckl9DrgTUwMs2ubcPp+y5UFEwDyT5Tgf4nVQj5UTQCfSwR4I7QSYM7rrCBsvGB1KveMKOuvu+fhHKc2FCvMff2fGR8h6ROm0qBhmu47KGdoM7aCOUTQbCi84fnC3yNQFQS0NYUqNb2aqQeB30bK9nNoJlwN9bVhh8oJJVBsTYU9DrNuHmR4DboS8Bmy70BczjCu4uWGlbsGLFmEfbufKgd9GhhYlDEpPxsEl/flr9L96ot/S7FLHrn792UWlw+h19kRy8MPhz1z2AUjjjDrN7LRCbcL1cj1CutUBjG/6uvbQ+lh25Vl1xJFyg3N4Yo/aRrxmEZ/z6jC91tvZmol4w0BkQPkw7BNeg7F/JGweRyddIrrw5X6sYALGNIqqFhb1GL++hnReOIESqTrfoGT8xSdfPwoYO0kmMhEVAviqcfrmmZdkHjkY/sgWLcSeyRklZ4zuVjkcer7kvsOGtcDV+mAW7xEdZaWJkC2NfwF7VlMW5d+pcZKRNYds1E0fk944rweFXllZFtaoz5zkO1ba9gJJhAqst7t8x8PfSFtxfxybv6u0kT5H0t6uL4s567KBoT1NzRn62C9H5feHNUXH6dZ7Ob03J5XLu/FFxh8APJZnd7H4teT3rGWEUsBnnETOX6E2PhypxHHHTvMAAH8gBuneeA5TOBlGo2ecHaMVGFTq0R0nz5WKOqqO1BsbZxtxxO3AQ5jD3H
 9GtsvCq0
 0KpNbUfSp5BG+q5saIogXrGx6rMQIgB4+MfD/gzwoQornt/pgxqAhs5U0kJsPMcq98WAcuIWcw9iHRH1FrIo3b3GQk/B5JvYuyNENKkdWMOecXccji5LRhgc+n0Jt8mJoPAdx2O0xSRh2ELKL7xXn6G7JDrdzj4ZngS0SzYxSNeRGu9gG1zPk5wItphZJD4Ag9EQI6kBGhRAYrssyCwsUr/WM2O/X05/+j85YCYItl/KN1PXuAOnVH+7UaJ66v9tFOtQcj22aTZVcs6IjHZg0pTFgkbzJxyX/JgQc6btITKGxbrr4NOo2rzSB1AXOauYfFtD55LfE3WVA0uSghmVRve8Rht+YyuIcrfzB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 01:43:15PM +0200, David Hildenbrand (Arm) wrote:
> Pages that BPF arena code maps are allocated through
> bpf_map_alloc_pages(), which does not allocate folios but pages.
> 
> In the future, pages will not have a mapcount, only folios will.
> Converting the code to use folios and rely on folio_mapped() sounds like
> the wrong approach.
> 
> Should BPF arena code allocate folios and use folio_mapped() here? But
> likely we would not want to use folios here longterm, as we don't really
> need folio information.
> 
> Hard to tell. But in the meantime, we can simply use the page refcount
> instead, as a heuristic whether the page might be mapped to user space
> and we would want to try zapping it, so we can get rid of page_mapped().
> 
> Page allocation will give us a page with a refcount of 1. Any user space
> mapping adds a page reference. While there can be references from other
> subsystems (e.g., GUP), in the common case for this test here relying on
> the page count is good enough.

Well, if we GUPped the page, it must have been mapped at some point ;-)

Anyway, I approve of this patch; it lets us defer the hard decisions and
work until we know what we really need.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>


