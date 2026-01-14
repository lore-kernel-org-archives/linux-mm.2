Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8135BD29FEA
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:50:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5B646B00C0; Wed, 14 Jan 2026 06:50:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E095C6B00C2; Wed, 14 Jan 2026 06:50:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D155D6B00C4; Wed, 14 Jan 2026 06:50:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA1CB6B00C0
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:50:42 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 645631A0473
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:50:42 +0000 (UTC)
X-FDA: 84330402324.19.39559A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 79959100009
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:50:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TWS2rvz3;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768391440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MvAZS5fdFxtiAw05eUzwN/90LQBTuxCee/lio+4MdUw=;
	b=SUNy12KAJwPfEpaVOpFgRPBA56a6Jtx8XGqalyOwphCHXN4bT9ODj4kOVLTLNuwrhl76re
	ZmtkZ5DGIU50uyuQgjaiRlwKGDba6TTrIwyY4AQYDN+ZJcUV2QURl95rAjCAaLHEW6qI0g
	liuwKdSwtiKr27nhXaU1OD5h8oj91yY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TWS2rvz3;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768391440; a=rsa-sha256;
	cv=none;
	b=ExHJni5ZyxY1s+DkcDV2ja2kR4/pbzfBu0axq9e2WN+nHJLho1HVbK9SvpNgPPkXxIlN8/
	0UtV/9ddQ9kMlyAG3ULIqXNF/MOOp23GVTS8H2e3YV7xg9+KTp0Yc/vzadLMoiLDwBNIrR
	ctjxMJhGN25ZuBdyCyrT/HssUXrbNL0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F73B43F73;
	Wed, 14 Jan 2026 11:50:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8026DC4CEF7;
	Wed, 14 Jan 2026 11:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768391438;
	bh=Drk4Hepu3L71mbtf6spc9HqRGMnd77mTtCAXfWvWNP4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TWS2rvz3fMhknPuavThmgxDfz8SSaKqhjzq1y1LVGSyoywq8AwyMJ2ZoeAGXtjnLo
	 omQ/vykoY0i5yc7IeDEhvoB+91ifQ5CtSQVodV95aX45PauBFiYt+wfVjD2tzFr7EA
	 DUphZiDOw1OTOiKx4anPZnYlNHHl7n7wvunqfLE+I/woDQ62n8blBaFQDPJB+MKQFO
	 jRp3oW0K6HxtyRxO64iouFv2RUtJp57qUrxU7bHqnDZ1JOZWaF6N6ELBiF/uAleLG/
	 WKY+gsgNP2JH5ZODJFLaFjWZtJQnpDG+jLticJnQLvx1dDdInOt7FlwG6vjudoLErD
	 4w8tTWVUWdjJw==
Message-ID: <06c2e619-0e60-4e57-b2ea-37333b2f6f5d@kernel.org>
Date: Wed, 14 Jan 2026 12:50:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v4 5/6] mm: khugepaged: skip lazy-free folios at
 scanning
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260111121909.8410-1-yanglincheng@kylinos.cn>
 <20260111121909.8410-6-yanglincheng@kylinos.cn>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260111121909.8410-6-yanglincheng@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9pmi9sq8ekwj4ce8xb9h6bk4q5r9g1mp
X-Rspamd-Queue-Id: 79959100009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768391439-520850
X-HE-Meta: U2FsdGVkX1/VeL7plIzI/Hk4RsrTeLnqfhhcdlefadCoONQaNHYK45PMIFEfEqtWnENcE5dAeW0cfuHLl5Lymd7ss0cWnSTkpt5XsvUPNHYak8NSHcSolzf3iq8Cssihv5x0XpwLGs29+RzeVFWSGyVP+y7cGbJPGl5eS02CHbK1xELbseT7T7WSC6wdN6GAPvrfgsfoMeHYcIQYQbgm2Dxg/kPVFfZyTO135Yyb190fFxjvyg1YztdtMUxV4jzNItrNYdUWGvgLgnrAUhpqZ/69m+2xURMGhrgVj6tGMKjO7pW2q0melBVFHIIgzFA5E+1sUfRTOP3itse9fguQ6CyW6tZg6LKxHGLE8l/qt2wjypi1eTgES51JgJowp5M1zCeV00c0qIQHez7G0dGHrAqj/clS9YDIdU2Zj/K7A8kQOFf6naQ4nre0GCLHYvgV+KMtOH8l8dUKEJCgqi0VfvM4TJCAZmfMKFbEDO/C06VkDVxycPQ5utCrhhKw35O/kptjpUvxysTinxbNwppEYmhvr7O/F7ELq18gh97AAm93727uiPBZpObHVzsffD3nDZyQyXTuH8Z12m3WY0FJaSP8mYfc5J3cHWGsOhMwYMROWvMf0EUHrPTZyDeYBOIvZqRYaUMA5kbHCEbeqgr9kQnp9C9/3V0QA4aK2+V1POddozdC0ky8TnlKEgJwUGVhGe6V2T/kqxvHwec79vQDJ1wPBotdal2mCVE7XQrv6VDKnMgn4ozi/zlhen+r141/TQrBNcGDYqGw5MknZElPkluZmQT0dRTw2R52egF8z1fP8gMZomz9ZjHbqSu6JOu9v9+7qLVH0Zv6Dn7EknXlyXsXhsIkj841oVtzjWZvNAp/7BUoBsMptnyD6dVDM28vwkwUj+rGinUcEwwYnIS1EFnL2PTI049ySY2kjvpiIKFJJKwwJ8WHgp6pR8REBnNHhVdbC0/ocTN0TwCzjkF
 9+GkoGWQ
 1CONtQ0jgGXCZ53yeDUx+Jlslhk6i/nfvz2rKvXf/mpUmfPhAZLGT96CsQY6VV7mttn8rICcdUdLkLH3in1kjs8L82c3cRzjgD0AkRAPyH28w6D1D1MBAqeVftveYt9ZnKVJdmIMh8wT08tNKdTWeW8VSARO54CyFGCX3XATMsoy9V5rz85HS3cb0yao1mia+d/xlqmKL9vVfk+TtXjUILUD6f+rKUE71Qv0bHoQUsh6VLHCmHW/RQHoGXJ9u/fyXH/axRYwvMWlcbAv4MPRlv9SPbtX+hnld9LlX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/11/26 13:19, Vernon Yang wrote:
> For example, create three task: hot1 -> cold -> hot2. After all three
> task are created, each allocate memory 128MB. the hot1/hot2 task
> continuously access 128 MB memory, while the cold task only accesses
> its memory briefly andthen call madvise(MADV_FREE). However, khugepaged
> still prioritizes scanning the cold task and only scans the hot2 task
> after completing the scan of the cold task.
> 
> So if the user has explicitly informed us via MADV_FREE that this memory
> will be freed, it is appropriate for khugepaged to skip it only, thereby
> avoiding unnecessary scan and collapse operations to reducing CPU
> wastage.
> 
> Here are the performance test results:
> (Throughput bigger is better, other smaller is better)
> 
> Testing on x86_64 machine:
> 
> | task hot2           | without patch | with patch    |  delta  |
> |---------------------|---------------|---------------|---------|
> | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
> | cycles per access   |  4.96         |  2.21         | -55.44% |
> | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
> | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
> 
> Testing on qemu-system-x86_64 -enable-kvm:
> 
> | task hot2           | without patch | with patch    |  delta  |
> |---------------------|---------------|---------------|---------|
> | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
> | cycles per access   |  7.29         |  2.07         | -71.60% |
> | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
> | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
> 
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>   include/trace/events/huge_memory.h |  1 +
>   mm/khugepaged.c                    | 17 +++++++++++++++++
>   2 files changed, 18 insertions(+)
> 
> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> index 3d1069c3f0c5..e3856f8ab9eb 100644
> --- a/include/trace/events/huge_memory.h
> +++ b/include/trace/events/huge_memory.h
> @@ -25,6 +25,7 @@
>   	EM( SCAN_PAGE_LRU,		"page_not_in_lru")		\
>   	EM( SCAN_PAGE_LOCK,		"page_locked")			\
>   	EM( SCAN_PAGE_ANON,		"page_not_anon")		\
> +	EM( SCAN_PAGE_LAZYFREE,		"page_lazyfree")		\
>   	EM( SCAN_PAGE_COMPOUND,		"page_compound")		\
>   	EM( SCAN_ANY_PROCESS,		"no_process_for_page")		\
>   	EM( SCAN_VMA_NULL,		"vma_null")			\
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 6df2857d94c6..8a7008760566 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -46,6 +46,7 @@ enum scan_result {
>   	SCAN_PAGE_LRU,
>   	SCAN_PAGE_LOCK,
>   	SCAN_PAGE_ANON,
> +	SCAN_PAGE_LAZYFREE,
>   	SCAN_PAGE_COMPOUND,
>   	SCAN_ANY_PROCESS,
>   	SCAN_VMA_NULL,
> @@ -1258,6 +1259,7 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>   	pmd_t *pmd;
>   	pte_t *pte, *_pte;
>   	int none_or_zero = 0, shared = 0, referenced = 0;
> +	int lazyfree = 0;
>   	enum scan_result result = SCAN_FAIL;
>   	struct page *page = NULL;
>   	struct folio *folio = NULL;
> @@ -1343,6 +1345,21 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>   		}
>   		folio = page_folio(page);
>   
> +		if (cc->is_khugepaged && !pte_dirty(pteval) &&
> +		    folio_is_lazyfree(folio)) {
> +			++lazyfree;
> +
> +			/*
> +			 * The lazyfree folios are reclaimed and become pte_none.
> +			 * Ensure they do not continue to be collapsed when
> +			 * skipped ahead.
> +			 */
> +			if ((lazyfree + none_or_zero) > khugepaged_max_ptes_none) {
> +				result = SCAN_PAGE_LAZYFREE;
> +				goto out_unmap;

I dislike adding another khugepaged_max_ptes_none check. Gah.


Can't we should just keep it simple and do

if (!pte_dirty(pteval) && folio_is_lazyfree(folio)) {
	result = SCAN_PAGE_LAZYFREE;
	goto out_unmap;
}

Reasoning: once they are none, we have a zero-filled page that e.g., the 
deferred shrinker can reclaim.

If you collapse with a lazyfree page, that content will never be none 
and the deferred shrinker cannot reclaim them.

So there is a real difference between them being none and them still 
being around.


We could also try turning them into none entries here, that is, test of 
we can discard them, to then just threat them like none entries.


Why don't we want to similarly handle this in 
__collapse_huge_page_isolate() ?

-- 
Cheers

David

