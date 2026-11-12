Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70462606A327
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 05:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=X1pugFsU
Received: by kanga.kvack.org (Postfix)
	id CF49E6B05BF; Thu, 12 Nov 2026 00:44:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA4AD6B05C0; Thu, 12 Nov 2026 00:44:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBB5C6B05C1; Thu, 12 Nov 2026 00:44:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A0136B05BF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:44:27 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1258E14025E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:44:27 +0000 (UTC)
X-FDA: 85425376974.27.574A1BB
Received: from mta0.migadu.com (out-6.mta0.migadu.com [91.218.175.6])
	by imf27.hostedemail.com (Postfix) with ESMTP id EDFA140003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:44:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X1pugFsU;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.6 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794462265;
	b=qcOd26DSkFoqqfnOzaV0UwOnRflCD6DutAykc/A1Ygrsi0TDhaRVrvPomzaZW51Qe1AC39
	QjN3Dndg0acNg0mdUjr3LrFRh4kRyke6P0ngicnF38hnDMLgsvvhm+bB2zzWsMCD4vCoKW
	MF4yjdS/t7H1NTsBEC2sOUPJ5vFEBfI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X1pugFsU;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.6 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794462265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fv8woWOOJ+ttnnLaTVcNI3Ww0pceRpqGqBuqXsTN2+4=;
	b=B/6KAYTJL5xgzm09xoV/6np+V6HISEaUIeb4yOQpbb3cNZuLlADYSoL/kSmPQPOJe9AQg9
	rKK+4DK5m1Atg6C+oA2f4LaxAR2w0JAOFepE9zsrOJj+qL06OrOrmt8MJCDsQ98qcgTtFs
	NlJKbvyxotcMzu243TYoCPKCf2G3suk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=qFLy/cCZWRuVvp8u/NE6bm9Bg5FRKCoK1ob4wHvg3yw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794462262; v=1; x=1795067062;
 b=X1pugFsU9AEh27z/8MMTSSfTKrXyALFymEeUWIdIFDiRTe7ul65g3ASthHcUlI3FE8NN7Btw
 9odfg8TOH97Wx1GDJD5Of+KQyA1S8jiyFnKTWmE07Dt9FczvVDHMJ/sI7AqLZCtmwCxOe9w4Xp5
 b5JAXTL6ylZDAqpUcgrC/MCY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5c3232aa448fa3e9;
	Thu, 12 Nov 2026 05:44:22 +0000
X-Mizu-Trace-ID: 5c3232aa448fa3e9
X-Migadu-Flow: FLOW_OUT
Date: Wed, 11 Nov 2026 21:44:16 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Chris Mason <mason@kernel.org>
Subject: Re: [PATCH] mm: list_lru: fix NULL deref when a folio moves to the
 root memcg
Message-ID: <avVSEx2bbM4abwln@linux.dev>
References: <20261112024140.648088-1-shakeel.butt@linux.dev>
 <26CC0CD2-97FE-4842-AE51-605EC77AC91D@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26CC0CD2-97FE-4842-AE51-605EC77AC91D@linux.dev>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EDFA140003
X-Stat-Signature: 4ktk55g7pzrs61s1j935i6cu7kk7aps1
X-Rspam-User: 
X-HE-Tag: 1794462264-179214
X-HE-Meta: U2FsdGVkX18pDGT7X692QzkKlOfsuJdsftzP0D7BzETUwOY1LHWUcfwyzbmlL2L/GxDhi2Cjwe8GCKquIU1wtu14vVcRZi1sXk7zDC9fkzm649JwfXATHvxVYVpcvr26QS2hdFI/xL0O5KatEif7DQEE30IvlpBnGqCW7MWfsCJAygrY2ku2ksPsNAq+LhSPcVxx5xqAIOOyd15fX2KdwCW+c/1MwKGuwTnXAC2n2YmQPbWn7uGcUL3yD2xeMcyPY6hkJVl9fFAZuiiDHspOSlGZ3KPZnJXdZB5rfJLR9M8plTDQR/NNOMcbh1sRVhHnytJ7jdy5CDzfL8bi33wDLREK9/BaJuPFuYjRzzxJw2jXZ0N20kpmFgLGM6swpfEP/oT8fr9r3jTCMfMgd9qHVprEG2pNLxsqgL2peFCzIpGVnjpT5zi67AcE+k4KeDdD7uifK1RSlkcePxjrNan6ygHf+QQzRT13f/8+t+/pMKDWpWDC5KTZkN488pnsHXKercBv/2S2HQbVl6Y4X43KxEWS1lxPNzKOpWbqMo1Odt5KTlSlAlz1oEkvzC09nSP//jzIHEn6iQ1p/aurBpE1e29u76S5IBJk8b9gPoKgciM7wg9Z6E5T1JmGWw/qj8u32u6cTGuIBJNxK7vEfCOFLNrjPKxHS2Me0b8qQ/sqI12rO2bP1kUFKNhlEWXwy6Iyr+cQ8noyhqIVYlPkcr3VaOflIUBG6jSIPzQjcF5oPctzWAzCagBHrS58FCSoAnYWc5ohbVKaCeMjM39NstpZTFkiUXQZOiVILNND2JdE1uX/JCsuzk5jZZ2TU0p9ldliZE0Ztynw5w5AV+VLvhi9Pe0hSqVmRtaxrbDBTtPQCFCxMTRcEbM3YGKJwkOD+GQWXvirqbEh/xGVm5D7kBCzYOuE+Vq+ALivSgLB5ghKiena7TFFFTZKiJfM+1Y3ARilATKds9WA/aoFkgTDKZV
 LUwz57Uu
 V2agpg610b0LXeuGe0Rbe9gFHhVBBNhim2ZNlu4kIJ/9z0fJ5J4sWpjAE5B5yowlEsv7Cx73ZnN22SDmbXUOmqrn7JKPfVwNYmI40gGAZGkN9pNE85up5/8AiZcvVcELu1K6j/vpz/MLDTc/JoNZv7v8GX17AIb5jfJyCbOGVR63YoX6kgnlfREYp/BBZpjos7+o0JDlitVvcAveYh7MyohqN1DqwpQOw6zw+JuPJy6Ho2dFGjICu5s1rF9Mrm6GdnNMmnS/5tCwkhFnwXNbY/kb4j0B5cfSeRy4Ky8uQD1a+b+FyKszeKsuYujuh3V8+xE6lt+CsiPoP+6pSUNm58spTP4KqQd1HrAZ/jX6DnqVMewuxRuGVar15gA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 10:49:44AM +0800, Muchun Song wrote:
> 
> 
> > On Nov 12, 2026, at 10:41, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > 
> > folio_memcg_list_lru_alloc() makes sure that a folio's memcg has its
> > own lists in a list_lru, such as the THP deferred split queue. It looks
> > up the folio's memcg twice: a fast path under RCU checks if the lists
> > exist, and a slow path takes a reference and allocates them. The fast
> > path returns early for the root memcg, which uses the global lists.
> > The slow path does not check for the root.
> > 
> > The memcg can change between the two lookups: when a cgroup is
> > removed, its folios are moved to the parent memcg. If the folio is
> > moved up to the root in between, the slow path gets the root, and
> > __memcg_list_lru_alloc() dereferences the root's parent, which is NULL.
> > 
> > Users see a NULL pointer dereference oops while a THP is allocated,
> > such as in a page fault, in khugepaged or at swap-in. tmpfs huge pages
> > are affected too, and for them the oops can also happen in reclaim,
> > for example in kswapd. The task that hits the oops is killed, or the
> > machine panics if panic_on_oops is set.
> > 
> > The race is narrow: the folio has to be moved up to the root right
> > between the two lookups. For example, its cgroup is directly below the
> > root and is removed, or has its memory controller disabled, at that
> > moment.
> > 
> > Fix it by skipping the root memcg in the slow path too. The root needs
> > no lists of its own.
> > 
> > Fixes: ae64f07a6a40 ("mm: list_lru: introduce folio_memcg_list_lru_alloc()")
> > Reported-by: Chris Mason <mason@kernel.org>
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > 
> > ---
> > mm/list_lru.c | 10 ++++++++--
> > 1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/list_lru.c b/mm/list_lru.c
> > index d1d256822ccc..566691ca3dd8 100644
> > --- a/mm/list_lru.c
> > +++ b/mm/list_lru.c
> > @@ -645,9 +645,15 @@ int folio_memcg_list_lru_alloc(struct folio *folio, struct list_lru *lru,
> > 	if (likely(res))
> > 		return 0;
> > 
> > -	/* Allocation may block, pin the memcg */
> > +	/*
> > +	 * Allocation may block, so pin the memcg. If the folio's cgroup
> > +	 * was removed after the check above, the folio has moved up to a
> > +	 * parent memcg, which can be the root. The root uses the global
> > +	 * lists and has no parent, so skip it.
> > +	 */
> > 	memcg = get_mem_cgroup_from_folio(folio);
> > -	res = __memcg_list_lru_alloc(memcg, lru, gfp);
> > +	if (!mem_cgroup_is_root(memcg))
> 
> How about using memcg_list_lru_allocated() to check this, it's consistent with
> the above check?

Yes, that makes sense. Will send out v2.


