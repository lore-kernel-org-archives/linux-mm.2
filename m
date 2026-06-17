Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81928CD98F0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 12:47:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7081C6B0088; Wed, 17 Jun 2026 08:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E01E6B008C; Wed, 17 Jun 2026 08:47:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D1696B0093; Wed, 17 Jun 2026 08:47:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2A17D6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:47:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A9B9BC1D3E
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:47:44 +0000 (UTC)
X-FDA: 84889381248.03.54E0C8E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id CF181180016
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:47:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G9akpU4D;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781700462;
	b=f8wYtRNK6cIDbBG0kOAGd9UHe0u8D87irGnUVsiGPMwhPvPtByfTGzQmMqV8AX2PghEGrC
	0w2Y8v58KL9mmNMc+2R0/gqBdFAzRF9OMkoKiZCynRG3w2OFJsKr0CJ94Qjwp+XvAmfGG2
	7LqjU5I7eLOYIFyvZRcY1Kfh4u9oyeg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G9akpU4D;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781700462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vNxoXi2Xs2Z/S6rhk+D/+FM4hX0Vdz/T8a58ZEMk0Bc=;
	b=qRHvuQLgeLckMLaEA7s/WeEN9EnaA/6pT4FwilSNnsQxZmYwYgnLWjkLNnDEGev2Vi08Po
	0k/YDcLpvnKPZKLnI9fXB/8GDhnybT7TzongW1c9jPDStsKeq13LNuJ++mbsbjnFnPJ45s
	ML4cSFF+E6P6LbIoR2BJ2twrBw0bNFA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CAF9D42D7A;
	Wed, 17 Jun 2026 12:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169041F00A3A;
	Wed, 17 Jun 2026 12:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781700461;
	bh=vNxoXi2Xs2Z/S6rhk+D/+FM4hX0Vdz/T8a58ZEMk0Bc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=G9akpU4D7eBc6wCgUNqt8IAwOznRQPfrvsitOvDpn9ghIDmykuLJXuAZRiZzYIrqN
	 ZrZwtORd3cPZZtHWJCCH9EGppeiIqORFpXs/+TqJiAjTVno0KCVoiOy1rfB1TMnntU
	 8ojqYvzZ+R4GL/j1UulOO6DEidtfjhwPo5ffDlJc+a5auvCs6pKQ6wUsyimWCHhmbt
	 99OxpUwNlADvzN6r0OiK5uK9jmv6zIv6gCkmlMX0VMtQ17DxkUNKO+cmumDy1qTDXG
	 LPjxgi75NAndePaWbiW8IeHslgbk/YCG9qUAvFuDsx8YIulPPV3H8/hXAa8xZd1xBd
	 2xW6WsYvkeCTQ==
Message-ID: <0ea1abc4-ff2c-4070-8bfa-67f6892aaca7@kernel.org>
Date: Wed, 17 Jun 2026 14:47:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/5] mm/vmscan: flush TLB for every 31 folios evictions
To: Zhang Peng <zippermonkey@icloud.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Qi Zheng <qi.zheng@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>,
 Zhang Peng <bruzzhang@tencent.com>
References: <20260525-batch-tlb-flush-v4-0-83789d6abc00@icloud.com>
 <20260525-batch-tlb-flush-v4-5-83789d6abc00@icloud.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260525-batch-tlb-flush-v4-5-83789d6abc00@icloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CF181180016
X-Rspam-User: 
X-Stat-Signature: 78qro8z8cocpkzznwjbeimboz4diyha6
X-HE-Tag: 1781700462-808644
X-HE-Meta: U2FsdGVkX1/5slX2oZGkXKEzP1aMtm0vQgmHxcNiB+M+vZQZ0AvP7jA2NJqxW/PKp0BuRkVGp2ZSqcAlj9PH16dML1pCnaR1P/TaFkGAyCHA+tZPFCLRoXdB8apmNiO/LccXPvqGSyiWfBzpqj6myq4AnHdw3Sh40FcOOsN7BcfxDmnqiBaF1kACIU6sds/kr3vGCoRpgoQb6eUoZ3p9241TqM5zMRvheh0TgcWpp2RMVTPU7SgjYBgRmXfU974Lfbss33jarG9hT0SEtT5/dIhnwMOamiThJJZsUhSTpojjIi3vKAwDW9COMeGpiQm2Ie4mBS+oTnAFhFpy8vTj+ynkB1GU+6ib4UIkegviFEw8+GuKv4KTbU7R5g8KQmZh/455q8j5ltScTzUqbBAWQE8sxjCHL6dsMBp3Q7MNWSH623QqlqQIbQNrzQ+0xgl4zzFNpXXbj7BDVLDU1KWizOzed0FEsUqwgkWecY17TOI2E2GAN7LHu+JTPB7FVm0XFMxnEXntRhOx9XHCWmHYUztNRTTURT2iJu28PkfVvXK7xTYmhboZ8nVC8RsTcSykiykY09gYBWqDlIHmxP/5twfYF7j+GyBB0U4LXrugObiCY9lmPzvUxYs2TxRnykRo/AidVE1xLCbA/L7M9pKEW+stiSlcf7ANk+MMXEOGgL48E9r6+24N3BIi1k3U65tW2QbWOMeJjUl5KYQU+qVK96J92BWpuUMIIIJO4T6WxYPEXuIoD96X0vBVIal0DfrFaDFvhfQaTuMxDYoSDhmTIuFZcMwM5ffgWbf4+qfbseeR9zibHhLY5NhgHdmCNiR1x9fPIzNUt9QlkjdBgJMSZjwYt6qCeM+cl9VSq3IJX++cxMEdhr6f5yBCc5GrP1CQv+1AkTDzQC1LIlm5P+tk31dq0RxBXDhxNUu3TVlnJZuOfI8XP3VtH7Rq6XZZ2M8Bv2/ms4G5NYKUtuni+qP
 JJ7psPvX
 r+hFx9zrpN8O/rM68KKzxeCdAh+x6pwn5BX7kJ8dH1ot9sBXbC5oXRe6DedIhK1gnsBCbykRyLTF/Xtde/8fKFgjr6oTB6R65U4OFPW+lS8UbMpympxVSY9rl5cQG06uhjyO07i4HS1WSFKbU3M28pVm2JZTTgWstm0wMaqz16wAMhBwTyLy/7f/QGaBGYxZkBIRiTlgWxD98BncPi/vu6DfDDb7AKypDHm2EzcbS2g86ExFky721R+q+hNeOPNK9edCWppFigkkbgDwnKSGZZs34G3yDMPjiQXh9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/25/26 16:57, Zhang Peng wrote:
> Currently we flush TLB for every dirty folio, which is a bottleneck for
> systems with many cores as this causes heavy IPI usage.
> 
> So instead, batch the folios, and flush once for every 31 folios (one
> folio_batch). These folios will be held in a folio_batch releasing their
> lock, then when folio_batch is full, do following steps:
> 
> - For each folio: lock - check still evictable (writeback, mapped,
>   dma_pinned)
>   - If no longer evictable, put back to LRU
> - Flush TLB once for the batch
> - Pageout the folios
> 
> Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
> ---
>  mm/vmscan.c | 79 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 71 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index abf3a2878456..c0d22afe67a5 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1221,6 +1221,57 @@ static bool pageout_one(struct folio *folio,
>  	return false;
>  }
>  
> +static void pageout_batch(struct folio_batch *fbatch,
> +			  struct list_head *ret_folios,
> +			  struct folio_batch *free_folios,
> +			  struct scan_control *sc, struct reclaim_stat *stat,
> +			  struct swap_iocb **plug, struct list_head *folio_list,
> +			  unsigned int *nr_reclaimed)

Two tabs. But this is starting to look a bit messy. Could a helper struct be
used to reduce the parameter count to something readable?

> +{
> +	int i, count = folio_batch_count(fbatch);
> +	struct folio *folio;
> +
> +	/*
> +	 * Reuse fbatch in-place: reinit only clears the count, the
> +	 * underlying folios array is still accessible via saved count.
> +	 * Filter and re-add valid folios back into the same batch.
> +	 */
> +	folio_batch_reinit(fbatch);

That looks rather hacky. You reinit the batch to then traverse the batch? There
must be a cleaner way. Walking and modifying the same folio batch in one go is
rather crazy.

> +	for (i = 0; i < count; ++i) {
> +		folio = fbatch->folios[i];
> +		if (!folio_trylock(folio)) {
> +			list_add(&folio->lru, ret_folios);
> +			continue;
> +		}
> +
> +		VM_WARN_ON_FOLIO(folio_test_lru(folio), folio);
> +
> +		if (folio_test_writeback(folio) || folio_mapped(folio) ||
> +		    folio_maybe_dma_pinned(folio)) {

Took me a second to understand why exactly you test for these properties. Can
you add a comment how these check here mimic what we checked earlier, before
dopping the lock?

> +			folio_unlock(folio);
> +			list_add(&folio->lru, ret_folios);
> +			continue;
> +		}

So, IIUC, what could have happened after dropping the folio lock is that someone
would have remapped the folio to user space?

Either from the pagecache or from the swap PTE -> swapcache.

From there, it could have gotten pinned through the page tables.

Is that correct?

What would happen if page migration finds the folio, locks it and wants to
migrate it?

-- 
Cheers,

David

