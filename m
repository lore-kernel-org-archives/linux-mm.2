Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78303C2A06C
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 12:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3BDF6B0088; Sun,  4 Jan 2026 07:10:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE9AA6B0092; Sun,  4 Jan 2026 07:10:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF5CB6B0093; Sun,  4 Jan 2026 07:10:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9FF8B6B0092
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 07:10:37 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 299DD140949
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 12:10:37 +0000 (UTC)
X-FDA: 84294164514.04.C00550A
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6AD4D20002
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 12:10:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ADKv9ZtY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767528635; a=rsa-sha256;
	cv=none;
	b=VdJcJI/I9V448FJKzwmAGPBXqFOIVRyT5WYFXtcxjv0G2HharWD7aRYxMx66Rid/A+vWPI
	oRpv2uzmYt3TL+RS3Ob+54ph5l803mv3XnGV1io/YZk/SLdIpAMDKcUpjo1s5Nqm317HmN
	9xdQh3zoEKOBvAORtlxiyFi2oxNwjZ0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ADKv9ZtY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767528635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xl5TaGEvBEf42HQCVCzbxis7qI6SCRKuu7TWZG+3I9s=;
	b=CuALLkjefhMR4OdMQ3Vo3ZLdgTt0s/BdpEBz+SYi39DmI50sWWhOprVe94CKzAiFQJUK03
	Hb6MjEUgHVzpbPxz4BNDqTQACOBUVg+fCWena/xGG9EJAatREa8WM72gugGaerQYPL3Wyb
	5UyFSWDWJwNhlCPDsoeeNCfCy1RguOg=
Message-ID: <9c82ffaa-5f62-4110-80cc-00f0c46e90fb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767528633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xl5TaGEvBEf42HQCVCzbxis7qI6SCRKuu7TWZG+3I9s=;
	b=ADKv9ZtY/3BIL0CprhLxL72rCOOuCfJBZ4cTq6K3omnUTVxyRYOkvdeYaTAYDgG4R34xbr
	ChecQwZkL4vO3IlrenVNMTS7v8+Xt51baMczv58MJHB3jyR5CkQRFcLkZIZoTGvkuBVce9
	hFmlIyixmevvL46ohirRS4jjZWYdmJ0=
Date: Sun, 4 Jan 2026 20:10:17 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 5/6] mm: khugepaged: skip lazy-free folios at scanning
Content-Language: en-US
To: Vernon Yang <vernon2gm@gmail.com>
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, richard.weiyang@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>,
 akpm@linux-foundation.org, david@kernel.org
References: <20260104054112.4541-1-yanglincheng@kylinos.cn>
 <20260104054112.4541-6-yanglincheng@kylinos.cn>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260104054112.4541-6-yanglincheng@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6AD4D20002
X-Stat-Signature: 14m8uwzxpfs1ju9tk5zusq39bfaysbib
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767528635-245330
X-HE-Meta: U2FsdGVkX18KT6jt4MUTniNFPg4wsv/lkEKafCZPajGrSFyAN2M2eqAxso+Ca+BKG7VdfNcZnVMDTVRrXUmYFx564SoPcVvOZncSTRwME0/TY89wMCxQ55it1TX86YYQCZqXYgCN5LKW9D4txSz6BS5994mp2NiaA5AzqWoMOffA/bcJutVHhgv8X7ugmItD4YGO83axycGOWB75sTijxpOQXrgwQhVdZFt9x07p/f7CpafxDbNQdTzznfO/7sBQ+5rK5pgAxjxMJ5G9ZbeztlMhhYOZOK2S8MypQY1Pdf5aMedQSFoI+wPYI89pt7G0tSvBbku43lGJyKITRNJ0KExEYOaweoeFE20tpcBu65sanCMXkx7ZjM3NUbUY75pFq2WfOy4gfjOIx5ZzxpzmVKxGkruptRG+Xlq7h23PhRnWPmC1hcf56pYfTKBJCmCbSeanOY+7VCHrcm05q+Hpmfi+QQAnd1DpSAvNIOsKOtjBt/s8gGovYTPOUkE8ZyCBB68I2mPTgVsoVLlW2lAn9F2gKArMDSDSIMPIUT/pyYHMHeKOQ5qVdbhLph4uCQIviZuHllEbNB5DObRytadzBXGZ+FKZHhy4T2BCNtdLjsgUsU9t0BBFTsgbz/NoMYkGVCxKnNpYgtyRW4medCegbL5KYGxL5ie4F9GRck0C3jxa46WrqQcCB2g9r4++CnKYSescFNd4nuhHh9pOondG2hHfNOUIBDE6f1ZhIguqopE21WyqffZ9F5GPiWXYi7PCpHByWSjyGFPOJMu2emiomIdec5wdcyJc1FrVE0sNL8l918iZTYwDuFcKtXBrvnHQPwLWTIDb6b9OL03znuaci9iwg68IZ4DzEoRWKTgwkw1I5PK5DuDTGJllD+fe9GLCIVoosH5AiXAo4YwGQjMiTUmWKWyxAMevjCTEdQhRbKTPUQebn7mIlg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/4 13:41, Vernon Yang wrote:
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
>   include/trace/events/huge_memory.h | 1 +
>   mm/khugepaged.c                    | 6 ++++++
>   2 files changed, 7 insertions(+)
> 
> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> index 01225dd27ad5..e99d5f71f2a4 100644
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
> index 30786c706c4a..1ca034a5f653 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -45,6 +45,7 @@ enum scan_result {
>   	SCAN_PAGE_LRU,
>   	SCAN_PAGE_LOCK,
>   	SCAN_PAGE_ANON,
> +	SCAN_PAGE_LAZYFREE,
>   	SCAN_PAGE_COMPOUND,
>   	SCAN_ANY_PROCESS,
>   	SCAN_VMA_NULL,
> @@ -1337,6 +1338,11 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>   		}
>   		folio = page_folio(page);
>   
> +		if (folio_is_lazyfree(folio)) {
> +			result = SCAN_PAGE_LAZYFREE;
> +			goto out_unmap;
> +		}

That's a bit tricky ... I don't think we need to handle MADV_FREE pages
differently :)

MADV_FREE pages are likely cold memory, but what if there are just
a few MADV_FREE pages in a hot memory region? Skipping the entire
region would be unfortunate ...

Also, even if we skip these pages now, after they are reclaimed, they
become pte_none. Then khugepaged will try to collapse them anyway
(based on khugepaged_max_ptes_none). So skipping them just delays
things, it does not really change the final result ;)

Thanks,
Lance

> +
>   		if (!folio_test_anon(folio)) {
>   			result = SCAN_PAGE_ANON;
>   			goto out_unmap;


