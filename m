Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94418606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 08:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S3jrazc4
Received: by kanga.kvack.org (Postfix)
	id 911246B0429; Tue, 20 Oct 2026 04:15:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874976B042A; Tue, 20 Oct 2026 04:15:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73E606B042B; Tue, 20 Oct 2026 04:15:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E6D16B0429
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:15:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 34CFA408D9
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:15:56 +0000 (UTC)
X-FDA: 85342296312.05.7861D85
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 78C40C0004
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:15:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S3jrazc4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792484154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7yZ3ca2iH2M2pKOMJWKH4DBzrr/28/Q1ygxpz33+pBg=;
	b=54oanPUTfiDAQtIrGJ9FlVhOiRzEO80nB9q3Cm3cECpV8dLlf3VIaFbiIAZRZ5fPOWnyGc
	CkFcaFJKDMnl3KkXVhO6fN2jBeR7jtC735zWNZDspTf+k075k955594a/HFOxuO2XOWlK0
	UIWu2KlSIYBfP7c3e+HbJt6FUADn0D4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S3jrazc4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792484154;
	b=QWC2ID1XlFuOQP/e2dgjTf68Q9oMEa1YQLaZnQR0ZoQM+K5rFs9lprPXSzwtxLqocaUZcm
	KlCZGv2FAExI/dVRkKMUFQfmowlq7owXcEv3NT8tUiN7jn9XI2DZ91TnVWexIhex3F4d6H
	FuIiOPPVlUIxdS1xO9eOwwwRaO8Wp3Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E540D60DAD;
	Tue, 20 Oct 2026 08:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913701F000C4;
	Tue, 20 Oct 2026 08:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792484153;
	bh=7yZ3ca2iH2M2pKOMJWKH4DBzrr/28/Q1ygxpz33+pBg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=S3jrazc4KQEXQCcFcr9nRwTRdwtDENHAKdj7Phkw8X7Bbc3ffO6Y6t4vZGoRWOzg4
	 OjNw74D8FOnAByQpid+l+oLVG5hwROi90zEAD37IjmH/nC6im7skFlSDnG6WKVg6KH
	 qMRMpr87w5sIorUMeNso613YNsJKtOPpVKXIeYo2DbXrU/LOBmBJu8XkqIUBQqEswl
	 ReT9vcusRxqmL3UO//Myvq77mb3baO9wTUfIvBkuenlNX69qUoFB7lt5qZRg5V/Ek/
	 7OqbP7PdnbFVQmCHm4WlMXieZNVcTyA/gGHuTcEyxfyLvcAK99iaN2cwmNhXU7jSPQ
	 xje4EPiyHA1Aw==
Message-ID: <a9dedb1a-3b96-496b-ace8-6135167a61f6@kernel.org>
Date: Tue, 20 Oct 2026 10:15:46 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: unqueue deferred split folios outside the lruvec
 lock
To: Joanne Koong <joannelkoong@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>
References: <20261019230646.3510790-1-joannelkoong@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261019230646.3510790-1-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 78C40C0004
X-Stat-Signature: k98rnsrcai4u9quh4cuoi68jipp51oy6
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792484154-156479
X-HE-Meta: U2FsdGVkX19AxqOzcDomCVA6BpjyclrzJTNYwmUfr61gIo3BeSSbF7J2F725KXrKklNWUqf4IodNLyrVhKd7N1Fodab6hIyUeN7N+r5LNHHnzRgABBGgNx9Nn01u8Ye6eZR6IHpiGsOXQ/Qhvg+I0s8QGD1zsys1+7BopDzsYuoEOKW7M/JzsE9fKnp7TnbvIyojxWf68W28LzS/iWM1b0rSNj3C0LEEBHjVJA8/L/4duR1k+CFbqi+6F6xHO1F5u16eh+NVWUPPBpDxuqPSC2bWQmFvTChYM3ZNrc9SgImddW3A1Hcgmp2rSpLdVJlKC/J50jrrFZIip3jMW8dXqgE9m5XOY3KMOQtLOvIkSJJzl+ylqVVNPyS4cq7nx+OehVSvefFwws2hf4G8fejH6fPU7lPKI5Z8gkOvP2n5XZ/vgdqgDw6Zb6BcNsmzBWda74Rcy5+rAfvFdbU+ERq27Uzm5wlYNY+e2qOhN9vrS6FCh4g2nrynTufyAme/9eAUHCgCl/oL0XAuyY7XdlavGu3WheFy5WlPIq+HFalV/og1Ung8CsW0pihv6vNIMQdr0Nd/fnZxy78lzkcL4r7IdktYMpojEBbitqWflbD9+8AM+/XzMwTo8AS7DM9q+XnPiKmNs/VIXL3qANCyIL2GO6Uj3sReUrW9sKi8+k3t+Wf0/CHJAQSAPZxdTP3x1vJdSYQ+r0cW7AzxFijX90XA+ExRMDKHkEDWlZYuSgIFu0dHjcD//9jBoSjzrLDhR4uTFoSNntCbbWCVm8DXLKq78wdV9CnEhITGd0M7y721UCR1+E6VL/QRPjMvLUcc4h08yGyrJU+EZVd1FwPWx78iTrnnGrfV61QbgN9yTZGhp+uj7wo0fs3H/1LIQgXOIIgbr6yLxa2bkixO4IXhzro+JNyqScP5BsKYJYQgInwyvks/8/6IOO6nWnviTekHkcmQXHoTMC0dIxorQ/7f5ii
 QTdNSeJr
 6zhUgvB6ijxhnbozEP3zYQ0yZEttFqQVgRS6q0XWFKjxUvzwmFrYSYcD3phxQLLceHp0UzptW4jk3d6wQGbtXU1O48gX7i9G+CPefLNILaztpkJiq6Fck3rcuDwsqkHgj8U4iGh10J6yvpYnOy0rXBbHE1aKLdeNHSbfpFcrYfay/++mzhsxR2vAvlt/sodrK3w6tA7vK3P+8dD87VRQcPCbTSKpMN0HYJFhuhIDe90yYaDkZskgDpwz6BTYS4CNsvAbK1G34rfz8+InMcsPnEUUNz3zf34qh741EnmAGxahCySBudte7ajz0Hg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/20/26 01:06, Joanne Koong wrote:
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
> ---

Thanks Joanne!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

