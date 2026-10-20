Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76973606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 00:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aO1PTJnF
Received: by kanga.kvack.org (Postfix)
	id 4EA706B03BA; Mon, 19 Oct 2026 20:16:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48AEC6B03BC; Mon, 19 Oct 2026 20:16:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38B0B6B03BD; Mon, 19 Oct 2026 20:16:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 096406B03BA
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:16:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 567D78087B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 00:16:10 +0000 (UTC)
X-FDA: 85341087300.13.D2A5FA7
Received: from mta1.migadu.com (out-216.mta1.migadu.com [95.215.58.216])
	by imf23.hostedemail.com (Postfix) with ESMTP id 43C39140004
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 00:16:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aO1PTJnF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.216 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792455367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yxOiEWJaqgHkBMG09/cBx6s6uMUt/RNcnnUvvQy8OME=;
	b=jFrhq2i0W7ZwnknweMTPJrmWxXD89RqdMxAlYuW/Wdgt/qaTr8cVgWWnDp0Q+UU4ueURjT
	A5l4DkEVP3XoCGMvkHO3jaijUaoatzOmRVNFDDfLPHS8KXkqICaCKY/xynusHHTR/isd0y
	Yqxt9pPp24WRxzpdoSsqWcn8wHXp6N0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aO1PTJnF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.216 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792455367;
	b=7CmzRMTEQhUAUrgtpGIPlYbWkCTGF6a2/rdciNQr5C2RY0koHW6uZa0F1tUN5CexkcelP0
	98ilCng8RNyyryZt3pVxvg/OvbRH21yz6vykbsEyqG/J+trQFGyR1D9pR5igTL/BBp2hZg
	bbi7CIwo7BCF+lcrcg8ZvJW8l5Gbudo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OQ7b2P4cSAuJuKX0jJ7hkWkBRiURgUV5lBZ7lUJp3tU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792455365; v=1; x=1793060165;
 b=aO1PTJnFC/zOnFbBnFSA3AZyCjoUOOJO6Yw7JLGEhdrDKpq63xT3B64JaPfoy6uME4Nv+bXD
 Idg9nPxQNIxdUS0SG85waup2xWQSUhqMJwTw1+MnDGeF/VZDxUHACPAyfapGjyn3WIpQSDcTs6g
 kfzQCIl4/9HN7ITZlFZOAm8I=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 57b2788d4b87db0d;
	Tue, 20 Oct 2026 00:16:05 +0000
X-Mizu-Trace-ID: 57b2788d4b87db0d
X-Migadu-Flow: FLOW_OUT
Date: Mon, 19 Oct 2026 17:16:00 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v3] mm: unqueue deferred split folios outside the lruvec
 lock
Message-ID: <ataymsNET7AV6qT1@linux.dev>
References: <20261019230646.3510790-1-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019230646.3510790-1-joannelkoong@gmail.com>
X-Rspamd-Queue-Id: 43C39140004
X-Stat-Signature: uedtygiq5rwyz6ujn1bt74xqook4dwu3
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792455367-159711
X-HE-Meta: U2FsdGVkX1+py4xwDiV2zvIIQy53gMbrT0gmkS8iDifhjLt8QMui19gUkLDzaq7t/qCV6xSOmIioGGA4MUBMPihq/jItyMYpcg7FuDPCeN1gPThSd5A56gqI+qQ1SfbsJPVII1541hdyWghFA8hTYfHtCQtV2VKFnoNlU3MkkQ2o6yZ9p+Jn0vUHAAAQnFXw4VTmSf3TJj1fLtrK9A5XLKUbeEiijy+ZBF2h0wVlZSjCptMXkNujEJx/EdN5Foye1Apz6S1BMLBqlKGTQFILQSuTcvMJqGcQ0TwqNrkxPmXViXlH/PjYRJRZhsG3Un1W8qDJ+OgWXMfb2nj8GoYqV3dfoxldzjSDM/jykDJHAAbsf39Vh1FIU5PAdycXCB3HycPH2LdvCfcy+Vs0H1DT6zExOoAI9MMlWSDy1xy+jCf5iFCmnupr2it+yrIgL05oCHE9kSKF344qajTNSvtk3/WpYxR4q47XK1/6suk7X33f4PvSSK5t58xHNYyWW+nTx+XDMSeVp31fBL8Hg52LaeopNPBx9eE4DjfqQ5yN8Jb7+DBuuDLM4sYHWPnLCsTbz9lOGExd4t/JTZCYd1nOtzKYzjJng2WKIr7Prv+LIbgbM7sNIGyZ2gQKQcFcX3gmW0/vKfEzdk0BiuLdeo6JyCuOrDX9RXDmWbeXEIGMaBEaf2U0EOGn4RpQ9u2dksgYu4KeZGj75rzPVYC22aMmJ0r7EHJGNveR/Gp+UpbsQcLN3KGK8ZwdxhwR3+dXcwpxVDQ4bdnTNs9I25ZeSDkpTFkO+eA6MZc3V+dI9R8LGybHGmYdtBd4ACoafGPT2T8KLkCMT+EYArb8yQxOzfC9wB7yeSuLeLymXlEmuEyIAEu7u6x4c95QkBC7QXoERshLBgrOyVByG3MEnX84i3fFKoPO86q81Mi1kseyO1uzDyb0Ve8/eK+dQfy5ALXeptMdPJECWto9o/ehHHx3rYB
 lFfrJpka
 ZyrMwADiv9cESVq0a5HUluV2KSqTEi5sxlRa2GDZnqVP7M6st5Vej1z+UMnYnER1EsU9jWSVAUJngdwwlV8x/Gw2k07NpYBJJyNjYJ2aNl9OTy771XNMb2CVKZf6azkelSsVxRVfaspj+0JklUgX85u+AymkDFcbEY//VeOStGlGZLTp0j+/6NZA+vZl6N3VjqHJaczXLPO/anVJPQ7haEAhiKX6NuVvaXJQx74kFhqMqjlCH7rgoTKSLpYAwIaNKsJgBb+AW0PXmJOOWmMMJsOLt1Rh6qQuaBTaQwNqDMR2659JPoADphwAjL+SGmo+YxgT+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 04:06:46PM -0700, Joanne Koong wrote:
> move_folios_to_lru(), folio_batch_move_lru() and folios_put_refs() call
> folio_unqueue_deferred_split() on folios where the refcount has dropped
> to zero. In these paths, folio_unqueue_deferred_split() is called with
> the lruvec lock often held (move_folios_to_lru() always holds it and
> folio_batch_move_lru()/folios_put_refs() usually hold it for every folio
> in the batch except the first). However, it's not needed to hold the
> lruvec lock.
> 
> The lruvec lock protects folio->lru and the reclaim LRU lists whereas
> the deferred split queue lives on folio->_deferred_list in
> deferred_split_lru. The deferred_split_lru is a list_lru with its own
> per-memcg per-node lock.
> 
> There are already other existing callers that call
> folio_unqueue_deferred_split() without holding the lruvec lock (eg
> __folio_put(), shrink_folio_list(), __folio_migrate_mapping(), ...).
> 
> Add folio_batch_unqueue_deferred_split() and use it in
> move_folios_to_lru(), folio_batch_move_lru(), and folios_put_refs() to
> unqueue each batch of zero-refcount folios from the deferred split list
> after the lruvec lock is released and before
> mem_cgroup_uncharge_folios(). This helps shorten the lruvec lock's
> critical sections, which run with IRQs disabled and are highly
> contended.
> 
> This came out of the discussion on v2 of the mTHP shrinker series [1],
> where queueing small mTHP folios on the deferred split queue was found
> to regress Barry's fault microbenchmark. With [1] applied and
> khugepaged/max_ptes_none=0 so that every folio is queued, perf lock
> contention showed that the extra cost came from waiting on the lruvec
> lock in the free path.
> 
> Test setup: 2-socket Intel Skylake, 40 cores / 80 threads, memory bound
> to node 0 so that all threads contend on one lruvec, with each of 80
> threads faulting in and unmapping 16 MB of anonymous memory 200 times.
> With only 16K mTHP enabled, this patch reduces the queueing cost from
> 15% runtime to noise, and lruvec lock wait time (summed across threads)
> drops from 491 seconds to 38 seconds. Most of the remaining contention
> moves to the deferred split list_lru lock, but runtime still drops back
> to the unqueued baseline. This test uses a worst-case configuration ([1]
> is expected to only queue folios of 2M and larger).
> 
> [1] https://lore.kernel.org/linux-mm/CAJnrk1a2PpUGTsCgS7jct2KET4K2zAL+_h+te8G1MaU9bXs99w@mail.gmail.com/
> 
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

