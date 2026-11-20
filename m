Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 457BA606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 09:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R4wnAftC
Received: by kanga.kvack.org (Postfix)
	id 3AA686B05B0; Fri, 20 Nov 2026 04:04:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 380F96B05B1; Fri, 20 Nov 2026 04:04:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 249846B05B5; Fri, 20 Nov 2026 04:04:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6BF86B05B0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:04:10 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3F708140D01
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:55:08 +0000 (UTC)
X-FDA: 85454887896.28.840F047
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7194B1C0008
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:55:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R4wnAftC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795164906;
	b=PePRl3TN8e3LO0e49F1gelm0ysCLNDm0V8Misu+hJQuTnbO+Iahj73lXDgf7hHZLWzToq7
	wutf5TWGS+xifN/IucuEPjfigdCZHMCHt6tD1YP32tziX9xy6kt2ww/yBHte4oRGLA6MAk
	xspzk32k1FOQFtMigj/f9+cVMps7pAo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795164906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U8QU7D7lH0dsXop+2OtcELI16mRcSojShF4LVc/fwRo=;
	b=WPMiU/vwUaXOJTfAcaeZuTcECagT6rmnodiOyBNkPzs9sSStjTOEAZoTvmbyHMrRFEALCp
	GVtv/nqtT9v15WBqZmnsKne5GRLhvYS0HgK7lrClJFKZV+BhVirGA0c4cLsaHHbNMWkzDV
	FaRaLpK3BPHd2v16cbF0YYdxAh6ejsg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R4wnAftC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A6B6341268;
	Fri, 20 Nov 2026 08:55:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F7D1F000C4;
	Fri, 20 Nov 2026 08:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795164905;
	bh=U8QU7D7lH0dsXop+2OtcELI16mRcSojShF4LVc/fwRo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=R4wnAftCC0fom7S86yQdMLAztpTkJyR+SbOiuZ2Ozzu+sMzSKTikRS4dXiGGcGn9M
	 97yNLrYYZrAXeKUbGLEJR9L3HgIFm7yioS0mdVLWgBYNBLP8AfetQfEOM0fBd0H5b/
	 iB7Oc9q2z/xqDblsboGFRJk3rVqMfc0OHAF+2mh6FYzxDASYeZ9htKMDlTWWFbw/Rb
	 J58CcUgsQcyLs5vPPz6A0TTQMztnjKsHI3uFsSicrPfyUiTXMy0NPBscUhQ4x2HXUq
	 JSbnlY0aXD0LV2uP0Umk63cQVz8de5ciy8NObFo6PTzApXUFpo9vjCfcv21SjUsq4j
	 hFdVFFXN0F7NQ==
Message-ID: <8a43c25e-0828-492b-90cf-beeb72ecdbb3@kernel.org>
Date: Fri, 20 Nov 2026 09:55:00 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: hugetlb: allocate larger early CMA pages first
To: Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org, fvdl@google.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
References: <20261120074701.48298-1-qi.zheng@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261120074701.48298-1-qi.zheng@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7194B1C0008
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: mb33gzixrqu3nuihukdeyz3kdycnoceb
X-Rspam-User:
X-HE-Tag: 1795164906-112411
X-HE-Meta: U2FsdGVkX19avU3gIfERJZ8tjXzc9HwxosHbXh7y8eakvG/VrtDqPRdcnI/TC3Fs3ya8wduIbzVdS/zmliIuSQvQUXvaq+oLO2oSF9XUYF9VdbgYgTC6AryqGTu3koGY2Xr7opvDkdPnfwlySQvLZHe71UDgtO8K/pmS5iWW4eDa6lh6ZbkX8yXneYCRqzNCikwNzr72jIeJ1TPaTQfHC7aofWVAp+0U6k/kUcWAkbGY6XY4KMju/J9IP/YFhqw/6kG6cXSuEnN+vtc17v9qHWrwqrgBfytZYFwt8tuzkR94GFV9RLkb7HjPDYf4NZtd/werV16Zdpjb4uaIKnI2jN7ypWePLdRgkwms5myT0JhK5umgEdQyjywvA2Gh8NrNIEn2PI8zTQ5INxgcKCIgNH4xu8LDIJGg/zQQSd7Y2XOKyQXzPXrjhszlvV5eLM9l8kJdD90vYXlfJUdKWEN71wCgF5IHq87QxV++zxhLXqu09Lq+jrGIWhJ5yMY7FBzCKgTdxDhKk+5ZV9ZwvtddAaGaKr04OX7nrfewuO9dRQZMKFTvla0dKPBxsFP4Z+yUCzukNOBvetkXtwUt7Je3o+Lpcz9zhSaiFYtWKLdVgmntGOnmgcK+MPUQ7pC+0L7sObxOarLu81kAE0eZkaHqRveMQ2jBmDXTSZA4PjAEftJ4OtieoAt0Sb9ywiByCofYsNygCOB07sJlzS5XqUthdVFpBR1C8ZLPwck+jltxKkgBYju15P+oYmBH12L4gYmhVu7g+iBka6AlRvBEXM+V1uqh27O+xuZSSYo5+c5V59RyW81EbtejoZQoEEXFwe196MFuPXXLvaDKtiqrza0ou6jodpGehsOVdOBIawYbCZyuPt8qAYQeokB6Y4S3oSmFseFCywEklKai2DSFRlibiQ5ubtKt+HfBMnnJqXlB6bwaYOcFKW8RhLF/QB+vtq/GUGg9jXbghZa8EvkxBh5
 X4rfJ0E4
 AgYnwv6FLea+H1UjxrPXd95M8os0G7kzfUMjsiv6NP92N+5VdOI2XxyiSngP7ywrMvMLHp+gMVvaVWs/hOisNKm5weAU6Yd5QDe6bkxkaCoUEpaAVWsIl6f6YMjhM1k3G4hhKzbMx7UANPJYTNc7ZZzQl0G0+gQrWC6bnLdhEoItoHncwgyLE3ZKM5Uo0OfvGjbHG18+sMDTExjyNXJxOrt6dooogKt2bwKbEWN9O1bhLm8+fozVABdhtZxBHJS4bqmeDNetZwt5WPZAIGh26nB+cPKR1qGJdC20qoE0SE16QH43MX8KD1RlkuKGLCWeilaMe9O/BezjnaUtzzqLoriVfZ+ADIBrZ33Sq3vfrEi1C6Fm7aLM+44G/ppS9fqZWOY+Ud4jFaTU9R3HZa1A6v7Uiq35w6cDOmRzshiP9YwAXSCjU6lfcMaB4dX37O04CJRi19OnWm2NNHYpHg2XZ0OFrt3QK81EiAJCLz3zYo50g2o3YrOaHajS6/i3sf+8Eevd7jD0qyJ/1qMnAvwoi5omJvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/20/26 08:47, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> With hugetlb_cma_only=1, early HugeTLB CMA allocations follow hstate
> registration order, which can depend on the order of hugepagesz= and
> default_hugepagesz= parameters. cma_reserve_early() advances early_pfn by
> the requested size without aligning the start of each allocation.
> 
> On arm64 with 4 KiB base pages, 32 MiB and 1 GiB pages share a CMA pool
> aligned to 1 GiB. In a 2 GiB CMA range starting at 4 GiB, allocating a
> 32 MiB page followed by a 1 GiB page places the latter at 4 GiB + 32 MiB,
> violating its required 1 GiB physical alignment.
> 
> Simply rounding early_pfn up before the 1 GiB allocation would leave a
> 992 MiB gap and advance the cursor to 6 GiB. cma_activate_area() marks the
> entire prefix below early_pfn as allocated and only frees pageblocks after
> it. The gap would remain reserved with its bitmap bits set, and releasing
> the two HugeTLB folios would not reclaim it, permanently losing 992 MiB
> of usable CMA capacity. An alignment-only fix would therefore also need
> to track and reclaim such gaps.
> 
> The same alignment issue can affect non-LPAR PowerPC64 hash MMU systems
> supporting 16 MiB and 16 GiB pages, with 64 KiB base pages and
> CONFIG_ARCH_FORCE_MAX_ORDER=7. The 16 MiB size then has order 8 and is
> also gigantic, sharing the 16 GiB-aligned CMA pool.
> 
> Allocate early CMA hstates in descending order. Each range starts aligned
> to the largest supported size, so this preserves alignment for subsequent
> smaller allocations without creating gaps.
> 
> Fixes: d2d786714080 ("mm/hugetlb: enable bootmem allocation from CMA areas")
> Cc: stable@vger.kernel.org
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  mm/hugetlb.c | 28 +++++++++++++++++++++++++++-
>  1 file changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4a448c5909d36..d69a9532ad5ef 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -4600,6 +4600,22 @@ void __init hugetlb_bootmem_set_nodes(void)
>  		node_set(nid, hugetlb_bootmem_nodes);
>  }
>  
> +/* Return the largest early-CMA hstate below the given order. */
> +static struct hstate *__init hugetlb_next_early_cma_hstate(unsigned int order)
> +{
> +	struct hstate *h, *next = NULL;
> +
> +	for_each_hstate(h) {
> +		if (!hugetlb_early_cma(h) || huge_page_order(h) >= order)
> +			continue;
> +
> +		if (!next || huge_page_order(h) > huge_page_order(next))
> +			next = h;
> +	}
> +
> +	return next;
> +}
> +
>  void __init hugetlb_bootmem_alloc(void)
>  {
>  	struct hstate *h;
> @@ -4615,9 +4631,19 @@ void __init hugetlb_bootmem_alloc(void)
>  	for_each_hstate(h) {
>  		h->next_nid_to_alloc = first_online_node;
>  
> -		if (hstate_is_gigantic(h))
> +		if (hstate_is_gigantic(h) && !hugetlb_early_cma(h))
>  			hugetlb_hstate_alloc_pages(h);
>  	}
> +
> +	/*
> +	 * CMA ranges are aligned to the largest supported size. Allocate larger
> +	 * sizes first to keep the early reservation cursor aligned without gaps.
> +	 */
> +	h = hugetlb_next_early_cma_hstate(MAX_FOLIO_ORDER + 1);
> +	while (h) {
> +		hugetlb_hstate_alloc_pages(h);
> +		h = hugetlb_next_early_cma_hstate(huge_page_order(h));

Was thinking that this could be written in a neater way, but it really can't.
Best we could do is issue a single hugetlb_next_early_cma_hstate().

order = MAX_ORDER - 1;
while (h = hugetlb_next_early_cma_hstate(order)) {
	hugetlb_hstate_alloc_pages(h);
	order = huge_page_order(h);
}

Thanks!

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

