Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF09BE98E0F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 09:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6AC86B0088; Mon, 23 Feb 2026 04:30:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E184D6B0089; Mon, 23 Feb 2026 04:30:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFA4F6B008A; Mon, 23 Feb 2026 04:30:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BA5C26B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 04:30:03 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A5CE5B938
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:30:03 +0000 (UTC)
X-FDA: 84475199886.07.44C2580
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id B0B55180002
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:30:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="oMu/GVUU";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771839001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UoKeWIMpI1rLpwJK3iBnTrFPqrBJctfIQPjBUc0gh/M=;
	b=Zjh0difIdEXAme7AaoJXz9nEBQAMV/WWWywiUZUI0zW27Uh955pJitvbLipdWire3W/J1J
	EnpTPn+vbprWr8CSoP7ssBXBDJqYEarrLhTA64M3v2LCKMbjpExD2PqqhQYXYWEXpaYshL
	B4FHqD6EQFZAVXSppoDhx9ASRoZB16U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771839001; a=rsa-sha256;
	cv=none;
	b=qGs1jXQlPJDcQrl423ai3BzL4KDqvCyGoEZKiolGdv41snLzr4vU3GOFqamxGic6zuE61L
	WFgN8MAhP94Tz8Aypx2tnC4dcvOCtGqXOlcB0LXtD+a3QMjYKNeG8fDKEqi27G/4Wjkrwh
	vXnKPuzcG2uYFh+pZ/o334obwANB9Ac=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="oMu/GVUU";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B0B5C416BD;
	Mon, 23 Feb 2026 09:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CBCC19424;
	Mon, 23 Feb 2026 09:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771839000;
	bh=7xweq4QPzkHbowTO2WGH3oP2m634ztmNkQ98oA7FLfM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oMu/GVUU6uQTbTnA3N5QZm1YoJdWSwp2y2Ppr3BjSDBcgiarwHhEPTKnPq4pD2aDL
	 wAU2NvoPEaawuI0ElZdzfBm6lxouNgaks13uuiAa8uvMPmHi5lypzmDf7tpROoh/w5
	 WQeiSvTp1jwNgsqOJCVp3+ITBKxQgjamnHTOL8CJHeEZNJTCbXePq82/jeZHMu90rF
	 qalNBfPvrytS1Wv+AMPRdGxRxiFOpTXMs+xCOPghWFk8vRevnikM2YIaiM4/iT1g2g
	 iYaNuoNUVqKZcOhu6LZhIQF4nYyxnnFpFW/m1F2wYyDUT1j53NcyBSrjgS3zJCURGt
	 GNQ03kjrHUfTw==
Message-ID: <2a6c4e62-1663-4a98-9adc-406a6a1ebfd3@kernel.org>
Date: Mon, 23 Feb 2026 10:29:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/mmu_gather: replace IPI with synchronize_rcu()
 when batch allocation fails
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 peterz@infradead.org
Cc: dave.hansen@intel.com, will@kernel.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260223033604.10198-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260223033604.10198-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 5ej11tcipxwnaiwshrzaa6cwr9axugy5
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B0B55180002
X-HE-Tag: 1771839001-641998
X-HE-Meta: U2FsdGVkX1/OQVglm7w9NIOW5Er8c7jbWOhR/u/QQE3wwJaYuc0fkC2mfEIUOEqlgO/wFZUggVrnGtO5ZygUHIoIl42fcwDS9+2Yb1D0LZjz8ZqesYvAHXX9xWncXJpzS0OqqwbFZM2fygSSmP162GxVxWMP/WzX5d+nvHsNR9MptBs52O9M2To9m+xJgsjcUykiKI9EK7GqOxn2X6X4+P7gHyWfln02zM1E/J+qvYVcBAOOplzV3UV9cotCtcsQPFBTVxi0rs3BMwwBncDjhXQ+c30Xc1ZDNbiNHqEBO4Gmu0pPBsLmcJnRyd/gMsoHzT8sUQABNXaVkNJcNZ+ciCEUT8IphiSeqi88tT4HfjSe56jEFWVAF8cCpstvJJGp/OamrOFfq1bIJHr8hmZWswVFgVnVQL6zh5K+vNYwQ9102lXZXPxv+FIdaA4vMMsFuCmnX7g2XG5HboXxT8qLV24zTfZgFu29DgMInL0tVRawrd4B/zY+EmFGhpkzN1psQvvL6zSiXQLPc5I5RASGTVOiO3xpWAePqTQiOik6qhtoBfEBUo8BYFMMIrr9VT1j8q/RkZutv9CsHR/4+WQFfwNYnIUNRUP2CQwm7Ef9pNKcL8KVTd2Zklk7Bg6Vr2LNGPv7j8xvHgXetIMil42jHp2DedvAp/LhmJxai9fHRrO0ZnPrSb4GroBJGtLtuf5eNPml4DvcFd2wiRQ+V54SrBG8GTV5YmZfXOe1Kvn06cT4qwt8TcOZJzr10Lfj1dBG6I/QczKVMvr7NKdxmqnLK3IRaBlE1XO9vGU6Wu9T/Mmg7w23r58BEJEpI0ug8dLcOsupbKIzzK4fCYVfuPdcpFoU9tOnH9z0MGaEH58JLANXp0xPKCY8fKHLcTY/Dp03Oc+ToHw2a6cQNNTMCtBjTfHRRhbEruItjWNkVTZGzcimVABWSgKd2qiGymZiDeLMuD+5YSrCtxhza0UEUMF
 qcNwYt2A
 pbuWo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 04:36, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> When freeing page tables, we try to batch them. If batch allocation fails
> (GFP_NOWAIT), __tlb_remove_table_one() immediately frees the one without
> batching.
> 
> On !CONFIG_PT_RECLAIM, the fallback sends an IPI to all CPUs via
> tlb_remove_table_sync_one(). It disrupts all CPUs even when only a single
> process is unmapping memory. IPI broadcast was reported to hurt RT
> workloads[1].
> 
> tlb_remove_table_sync_one() synchronizes with lockless page-table walkers
> (e.g. GUP-fast) that rely on IRQ disabling. These walkers use
> local_irq_disable(), which is also an RCU read-side critical section.
> synchronize_rcu() waits for all such sections to complete, providing the
> same guarantee as IPI but without disrupting all CPUs.
> 
> Since batch allocation already failed, we are in a way slow path, so
> replacing the IPI with synchronize_rcu() is fine.
> 
> We are in process context (unmap_region, exit_mmap) with only mmap_lock
> held, a sleeping lock. synchronize_rcu() will catch any invalid context
> via might_sleep().
> 
> [1] https://lore.kernel.org/linux-mm/1b27a3fa-359a-43d0-bdeb-c31341749367@kernel.org/
> 
> Link: https://lore.kernel.org/linux-mm/20260202150957.GD1282955@noisy.programming.kicks-ass.net/
> Link: https://lore.kernel.org/linux-mm/dfdfeac9-5cd5-46fc-a5c1-9ccf9bd3502a@intel.com/
> Link: https://lore.kernel.org/linux-mm/bc489455-bb18-44dc-8518-ae75abda6bec@kernel.org/
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Suggested-by: Dave Hansen <dave.hansen@intel.com>
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>

I think it was primarily Peter and Dave suggesting that :)

> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>   mm/mmu_gather.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> index fe5b6a031717..df670c219260 100644
> --- a/mm/mmu_gather.c
> +++ b/mm/mmu_gather.c
> @@ -339,7 +339,8 @@ static inline void __tlb_remove_table_one(void *table)
>   #else
>   static inline void __tlb_remove_table_one(void *table)
>   {
> -	tlb_remove_table_sync_one();
> +	if (IS_ENABLED(CONFIG_MMU_GATHER_RCU_TABLE_FREE))
> +		synchronize_rcu();

That should work.

Reading all the comments for tlb_remove_table_smp_sync(), I wonder 
whether we should wrap that in a tlb_remove_table_sync_rcu() function, 
with a proper kerneldoc for the CONFIG_MMU_GATHER_RCU_TABLE_FREE variant 
where we discuss how this relates to tlb_remove_table_sync_one (and 
tlb_remove_table_smp_sync() .

-- 
Cheers,

David

