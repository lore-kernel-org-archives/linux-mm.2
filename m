Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6D17EA7943
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 21:24:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 171736B008A; Wed,  4 Feb 2026 16:24:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 129196B0092; Wed,  4 Feb 2026 16:24:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 052076B0093; Wed,  4 Feb 2026 16:24:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E8F736B008A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:24:03 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE3C3160306
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:24:03 +0000 (UTC)
X-FDA: 84408051966.27.801E03B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B7933140003
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:24:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TB/gBxn0";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770240241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VqWwWarWsfMjCDqPsqjyT88dGeLq8ZVXtXvMxj6zq40=;
	b=QoSZyT5DmlETzJqLXn7OWbfSog2DRuOVwjc2jfm/TeyiSG+TIFEft/WUavyk/i9HRrCcE9
	GDfguiuer166o2tCcRrdhOfZyyrTc8gmzCK8UP2kd6OBPP9BD6NVYr1daALGevazm+BdGZ
	WdZD2txshsQefZU2tFFPUn1dXQuDdWk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TB/gBxn0";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770240241; a=rsa-sha256;
	cv=none;
	b=x+54BpPqwe31p3ip/oSILoSa2BY/+yWxP3XKl1onXiyjHKisfPjwLmFtyniDS3ArTD+oK9
	yIfPDzPLPwAZjnUzHyZxtWS/eb5WxdcaXZUS05qdOEslF124T4CkHQ19Sur3z9Bjg15415
	0Hx0ip0Erp1WNVIOhK6mb6hMhdN6Xws=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B0FFE4003B;
	Wed,  4 Feb 2026 21:24:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE01C4CEF7;
	Wed,  4 Feb 2026 21:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770240240;
	bh=kvt6RfSq5mmKVHA1/fGV6JgGgvGhaQbjcEYu9QCJ8nM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TB/gBxn0vfFQQb9YORjszU1lX5IkTjOJ1u3/7THf65vM0u8ZNr0FV57VeiWMStM/y
	 2YtN6AkLRFjRjW/c+r6hgkgX2JroCZ0CdqdKUjjql+ffDFpo40G8TIwxBIGzFtI60W
	 7szzPIuh3l/Bdd/mAtprfk8Q2UXb92+6iAs9OLVUg9wGmMTWnmmi/TZWZooZsLcOa7
	 OyNIpwTRUbbKYMoxw3mF2UjMymhO99IJ3Bok++/fR9erkdPjTTOXhXUAp7y0ix1Mcp
	 OSaiXvkODeedQKWUcj3A1jg8AmfU+PCAnYrGGHSSdAi0AMMl6mLgvpaIPWkFly2MNh
	 xT557Xa8tKrCQ==
Message-ID: <d795eac4-b52f-4984-a92d-6bfc9d84121c@kernel.org>
Date: Wed, 4 Feb 2026 22:23:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v6 4/5] mm: khugepaged: skip lazy-free folios
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260201122554.1470071-1-vernon2gm@gmail.com>
 <20260201122554.1470071-5-vernon2gm@gmail.com>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260201122554.1470071-5-vernon2gm@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B7933140003
X-Stat-Signature: bo5x4suf8pxx5adu6ihq7p769adqa1ss
X-Rspam-User: 
X-HE-Tag: 1770240241-14842
X-HE-Meta: U2FsdGVkX1/FesqCrfFza7ZWHyuNNFOhCPylLYqbb9Hu3lrQEpXAAe/bWmzHXch8hgfVFcfRapcqVMAseYq1e/BMdBpgQkqEVtQX+MC3klsACfU9z7P4DY7hBdUvRBZX791BoQt5ocyXmt/DYoOOPiU6ykeEDRS99R3aWNLGte8lKDHd0/+YWC5clhwJiBcNhJN+spGnJJC17pXCyp8DdG6M3D03UIU/nX73Ibv6tPCK4QcREmyiowUPDBowdWDL2c/b8b9rS8xpbOgrL/VV9a6RNgAEUUcrJHX96NWkbDPOwA3LEDaPhHVETve7edtsxTyh1xHO32UbLiLaos582JSf/LyUujCRFe8kQGY4IUiUMHGs23943BHYrsDN/FF+Q7f4F20bMQcrYcWRwOcbfF5mwdR9Ryi7J8p8Y02P/NDZXArY+qzpbpYIM9FnSQWMchCA/Xpj7si5/XQUpJPvuPlpMgz1PLo8+d4p4zSc5vXOJ2f67zG9TC9wOABKjM5wP0PRlU7Nb7hLlbqfgdbS6ezI7653uV0ycc1V+2ddX8alYaDUxkdRXpWTZk1vmEP/DsQzrZ+xflXn+BEmtqKSYwViuCFX9dvzS30zS2T8Po5XzejURzVjvXUgSWBq3BpEVTzMxidbUaksttVw5k2HDqfU1Sd+tn2axAPEx3wovscOXhDoatmYVzBNMJ4NDGrMtQOMhZ2f4P7/3k7AM788QYNec+ff0qxMz5U2GOlr+XMogkJvmQq6CcurFlQy30A+psfpccuuArnhWdLlCuSYgd42O2Y9qgfBTpFBV5Uf6+EN19vIOMbaY/kj9h69obsHnr95rnkScaSpiOa5jW6fX9RNY80/AODX8TkQ5IKikK7lb7TganykBTnm6n7zbeDwkogwOMwG3ThgM1fssBh1kNojYUUaJ9F+X4DFtD6hNpQmRuQoqWEu2Lu3Uhw7ssNpFLkkF9Q/Z6vvkFWm423
 WYK6cI+2
 dYzWXQ1g750rAVHskiLP2Ofd/9NgbnVAiesFHf5ba5X75szALnQsPQXLJ//47KieKk1JfzIHTXFTL1pdOSYB0dT9f/4fOVgQHUvDtsy43ADHcznPCaTI7yumY7NL4p4+kyGFsvFLIOGqCWhIZkLx8vCTgkixXKFwZDzTO+BUDIeiPYj6sTUiCH3XPBCM1B3ECNJoyTIUFaxp4ic0lRf9/+8p46bxecO0ZZMaVQ1sn5y/UgVkOgRgvm57dZSczVcN9Jb+MWIGBknbPV5LDa7MTyBGdSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/1/26 13:25, Vernon Yang wrote:
> From: Vernon Yang <yanglincheng@kylinos.cn>
> 
> For example, create three task: hot1 -> cold -> hot2. After all three
> task are created, each allocate memory 128MB. the hot1/hot2 task
> continuously access 128 MB memory, while the cold task only accesses
> its memory briefly andthen call madvise(MADV_FREE). However, khugepaged
> still prioritizes scanning the cold task and only scans the hot2 task
> after completing the scan of the cold task.
> 
> And if we collapse with a lazyfree page, that content will never be none
> and the deferred shrinker cannot reclaim them.
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
>   mm/khugepaged.c                    | 13 +++++++++++++
>   2 files changed, 14 insertions(+)
> 
> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> index 384e29f6bef0..bcdc57eea270 100644
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
> index df22b2274d92..b4def001ccd0 100644
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
> @@ -583,6 +584,12 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>   		folio = page_folio(page);
>   		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
>   
> +		if (cc->is_khugepaged && !pte_dirty(pteval) &&
> +				folio_test_lazyfree(folio)) {

Should be aligned as

		if (cc->is_khugepaged && !pte_dirty(pteval) &&
		    folio_test_lazyfree(folio)) {


But you could just have it in a single line.

> +			result = SCAN_PAGE_LAZYFREE;
> +			goto out;
> +		}
> +
>   		/* See hpage_collapse_scan_pmd(). */
>   		if (folio_maybe_mapped_shared(folio)) {
>   			++shared;
> @@ -1332,6 +1339,12 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>   		}
>   		folio = page_folio(page);
>   
> +		if (cc->is_khugepaged && !pte_dirty(pteval) &&
> +				folio_test_lazyfree(folio)) {
> +			result = SCAN_PAGE_LAZYFREE;
> +			goto out_unmap;
> +		}

Dito.

> +
>   		if (!folio_test_anon(folio)) {
>   			result = SCAN_PAGE_ANON;
>   			goto out_unmap;

Surprised that there is no need to add checks for SCAN_PAGE_LAZYFREE 
anywhere, but it's similar to SCAN_PAGE_LOCK just that we cannot ever 
run into it for madvise.

Acked-by: David Hildenbrand (arm) <david@kernel.org>

-- 
Cheers,

David

