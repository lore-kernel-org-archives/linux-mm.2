Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEAC4C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 15:13:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A61C26B007B; Fri,  7 Aug 2026 11:13:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A12CD6B0088; Fri,  7 Aug 2026 11:13:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92A266B008A; Fri,  7 Aug 2026 11:13:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 701B56B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:13:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 014071A03FC
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:13:21 +0000 (UTC)
X-FDA: 85074817044.22.4B0B5F0
Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1CE431C0016
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:13:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DRCYWaFH;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.175 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786115600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+d1J4LC7Erxo96ihjUCf50fLWAw7uZ8BNFe2NoXbak=;
	b=L6KDGcm0ktLrzJGS9Hl4/YvRBI0/msdvLBW78bPYcVix49yJzIjyIPAG+NA52wnwZawac9
	SUqy+BGEN3Ure01juHa2NDM6POIyGugaUzqQVf2pCq9kH4260y2oRGyoeXC3Pj5YUkzAWj
	YC/1gtSQTbn/rYxNVj+TxszzBSaH2oA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786115600;
	b=2I6eFBaSggJb2Y0UJjKWf4n0TeEq01Ql4G+08Jo6/abyudXz08JpmKc/DPOD0Sr3ayYS+p
	DnOwIRsIe6tMcE6gqICtrV3X+h+noTUt8e6mNHufdWY9ffGyIJWfICCo+7+cEwpM3nLtAj
	T63A5dZuz7zqzRBszX0EIB8OF4O7Fvw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DRCYWaFH;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.175 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 7 Aug 2026 08:12:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786115598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f+d1J4LC7Erxo96ihjUCf50fLWAw7uZ8BNFe2NoXbak=;
	b=DRCYWaFHA69mf5mz1kk9tHFtqgLW9FJ7dyfDDpj5KsAf0euN0ucbfk/fAPhYoFR/DGQqA0
	0fcsXLkQdR30ujBE0w1O2l9oCD4MFyWT2CPo4yIWz0t0sZ1Q6mfInxABJvA5iK0HP0O+O1
	xx6xGzJ5j34gthlvzEr+jGhkMpX9coE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Ketan Kishore <ketan.kishore@oss.qualcomm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Yu Zhao <yuzhao@google.com>, kernel@oss.qualcomm.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Prakash Gupta <prakash.gupta@oss.qualcomm.com>
Subject: Re: [PATCH] mm/mglru: fix lockless folio_putback_lru() race in
 evict_folios()
Message-ID: <anX1F_q_BsMjuqB6@linux.dev>
References: <20260807-evict_folios_race-v1-1-b167c6b4cfde@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807-evict_folios_race-v1-1-b167c6b4cfde@oss.qualcomm.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1CE431C0016
X-Stat-Signature: brhe99j6wguyn9hwpdiw7xrxahr7kbty
X-HE-Tag: 1786115599-701511
X-HE-Meta: U2FsdGVkX19eZwfu7Q6AEubxzA9yc+gOyr7ZIlYQdqqedxbEz5plENSaIkSsPnWc11rfYdpRIbFRXgqxoGokmotaf7tiGPXAFXI3dARPuh4z/kXuZWkAiaBSmkkqaD75CNmdXnyI2Obxl9d4gBlfek7SB9fPgyAlutNrMddzcrZxXAbC5DfdEvpNOrZGw1NdJgt6+dMAOjxR3GozZQeSMjzew77uban+uF5qBW601W4IrErYWTG3AU5Q3BUIH9oBZeXPEjahjVda5epDAnXq9qWHGGtW7NOIP/6S5S3igt0mdSo6e5y7eUpRlLMe/B9Kc3mMU9cxEwuCtMoCCe/ANh6ys6gyLnj3LGuwoxWHCHCYu7SIe5fA7AuFuMgv5BksS4z/TWMOvyTgR48kQDZLpJSV6ZwIptTN3UWcP3DqN6vbhQtOVKppJHDVX1hZe7f8No6zvtjCZ+jCIPe+nAv5BRqlv7xa38h4QwWc6qEKHgKTUx5iYQ5+rW9iH7RZI9A/7B5ckvBqc4mfs4NDyJlyy6ZL1XpwcS4p0O3wSg9ESY2GoWtTQpRsZNlMxYzznTaEH7Ldb3CHyHFs9wmWnBmZn2rd0qzQacJcB/YVjh7aBWEy2nJUwjDTx0StVCY+deDbTn+4uFhf6yQXjhkv/ufkEyu7ZnRld+NSzpc25HVNY+VY7LdUzJAO2IqkXEwwaq79NUdM8DJvgiIyLlGNtfvPNfIuR8cVPIQ4nbF4eaT2eyt/Upl4KXPlLdIl+dR0gH+cYO8WxjcePOtLGIs5V7kMeRG3u+DzsxT/TwbA5abJVMtb+ef7lmB/culLZx9SpwTGAFFF1RPOwbLkRl8yijGH+1XIWGPQ56tPd6EWU/g3NdIa6UQVvyAWlbeIX5KLdXyzDzKw/yvaJxR2Pc+cQwLCbPl1i+3jmaHvz9y9ZsHLr8RZAtW6Nj3L0ZPNiCs3cJLR+XjUp58lySfLj5/ZiOk
 g5o66YQ0
 oKZPbGxe18RvGiy3Nn3kCTDsuN4xifi6YVCZoegaqmETGBzOD9GWcPnmbxlZAXp+0YqJ27FIKOU1BJte9FuxwWyacWlXHNIEMjXIHJ5iZqPGE/Xf+UuWBufzcGbk+CPD7j2QwapPHWP3eA9Dv4X/HEmMYRFs/0oiTSvhXIH+LvNZCafnZaYyzh3s4dfWGnfpuSTOK9UD2ESZpD6oPp+/90b23sI2RY0PMW9OcM6jl1AAaxqEvbwjMdcYlmUNpaJai7k9+AXtErZrrNWPzUVMZPlsitA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 04:00:30PM +0530, Ketan Kishore wrote:
> folio_putback_lru() requires lru_lock to not be held by the caller,
> but it internally calls folio_add_lru() -> lruvec_add_folio() ->
> lru_gen_add_folio() -> list_add(), which modifies lrugen->folios[]
> without acquiring lruvec->lru_lock.

folio_putback_lru() requires lru_lock to not be held because it holds lru lock
internally.

folio_putback_lru
  folio_add_lru
    __folio_batch_add_and_move
      folio_batch_move_lru
        folio_lruvec_relock_irqsave
    

> 
> In evict_folios(), lru_lock is dropped before shrink_folio_list() and
> the subsequent list_for_each_entry_safe_reverse() loop. When an
> unevictable folio is encountered in this lockless section,
> folio_putback_lru() is called to return it to lrugen->folios[]. This
> races with any concurrent CPU that holds lru_lock and operates on the
> same list (e.g. via list_del or list_move), corrupting prev->next.
> 
> The corruption is detected later when move_folios_to_lru() re-acquires
> lru_lock and calls list_del() on a folio whose list linkage was
> corrupted, triggering BUG at lib/list_debug.c:64:
> 
>   list_del corruption. prev->next should be fffffffeead4fbc8,
>   but was ffffeafeead44188. (prev=fffffffee4fc4c08)
>   kernel BUG at lib/list_debug.c:64!
>   Call trace:
>    __list_del_entry_valid_or_report+0x100/0x14c
>    evict_folios+0x145c/0x16dc
>    try_to_shrink_lruvec+0x228/0x35c
>    shrink_one+0x94/0x158
>    shrink_many+0x1c8/0x1f4
>    lru_gen_shrink_node+0x94/0x110
>    shrink_node+0x468/0x8b4
>    balance_pgdat+0x4f0/0x9a0
>    kswapd+0x268/0x470
> 
> The race window is amplified when unevictable memory is high, causing
> folio_putback_lru() to be called many times in the lockless section.
> 
> move_folios_to_lru() already handles this correctly: it drops and
> re-acquires lru_lock around folio_putback_lru() for unevictable folios.
> Apply the same pattern to evict_folios().
> 
> Fixes: 359a5e1416ca ("mm: multi-gen LRU: retry folios written back while isolated")
> Signed-off-by: Prakash Gupta <prakash.gupta@oss.qualcomm.com>
> Signed-off-by: Ketan Kishore <ketan.kishore@oss.qualcomm.com>
> ---
>  mm/vmscan.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 26436059ea39..7c4adba13e4f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4923,7 +4923,9 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  
>  		if (!folio_evictable(folio)) {
>  			list_del(&folio->lru);
> +			spin_lock_irq(&lruvec->lru_lock);
>  			folio_putback_lru(folio);
> +			spin_unlock_irq(&lruvec->lru_lock);

This will introduce a deadlock.

