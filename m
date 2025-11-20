Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7DDACF8576
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:25:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 228906B0096; Thu, 20 Nov 2025 04:25:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2005F6B0098; Thu, 20 Nov 2025 04:25:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13C5D6B0099; Thu, 20 Nov 2025 04:25:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 020346B0096
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:25:09 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF3A21407EF
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:25:09 +0000 (UTC)
X-FDA: 84130451538.26.21A3163
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1FB6B140009
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:25:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uwLOIVrC;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763630708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rWSmvSxXpg/mSZQH6kbqxm/dkIi5PSx5PsRdWHSKC6k=;
	b=yxlYHsoMzXjBZR5Al1Fw3VzwDMPIyrU0UNKlFhZKHpWBQqL4JCWWU2JQ8OZ55T0mXosrq9
	AXfYPS37pgJTxhKhzOJIkaCY+CpMvlCHBYjWHVZz3kOIlnIRmgD9G2xBxpspwI5aRMNKKh
	vV1EIWvzTjlgcv2QrZF4cbFPoS4s89M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763630708; a=rsa-sha256;
	cv=none;
	b=npcvzna0X1yykq3jRA4w1BVSUGgsS/nxUwtF9EI4UmCtEsBgkiqUsaMIp7YEN6gybard40
	XrMD3QbeeT2yfdxMczMeo3UnisTgN9UEzt15/dVbY0er+Xv0pXwhIVCQb4ROaRUuTIV6y1
	rEGUX8FNIxsIRTRpI/Dl79WkRnR6YJM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uwLOIVrC;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6CE1F60007;
	Thu, 20 Nov 2025 09:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8E6C4CEF1;
	Thu, 20 Nov 2025 09:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763630707;
	bh=Zxcj9YrpAEfvPY91o1U5hwiHCXNZdysrcM08YutqhjA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uwLOIVrCHyj293/4WH4HOG2zu281VSxljjgOmaymHYjlguERPfAvjpub/HQXMaBV3
	 MndUSzl+xdJ8n6JaBOtzKpWB1DbPDCNe/+bZKBLtAV6C8SJAgHO9iQQ6phudPOCvEt
	 yzp5BKvBVMliCmTQjTZBAfV0UB4leb7yzJ5V5vhTjJRDnseA2Bh0fx6+sV8qEy6VgS
	 tB29W2mj6vEzz8sO8gakgTCpvxTjCXTuQim5ckt/P4nF/5rXOVHSiqdq9zEukpNm3Q
	 2cFd6XYCoDx8kmoueTfcrs8w8yvqO0o9js8bETMGbuvRdVUN6AK8MX4foCpnH0OJkr
	 mQGfW84PZULcQ==
Message-ID: <875584d7-5a68-4f7a-8549-2a9cd6c7f9d8@kernel.org>
Date: Thu, 20 Nov 2025 10:25:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/3] mm/huge_memory: prevent NULL pointer dereference
 in try_folio_split_to_order()
To: Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251120035953.1115736-1-ziy@nvidia.com>
 <20251120035953.1115736-2-ziy@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251120035953.1115736-2-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 1FB6B140009
X-Stat-Signature: 6fhx5u8sa1bige8m41czqsgp5jwunnar
X-HE-Tag: 1763630707-404243
X-HE-Meta: U2FsdGVkX18Pz6kIqq5Czi535TP6564b7L6Ps6MiyUDJE9BZ7tuXmJ3NFR3+CAuHuPS5bOdr6Owm2iRBkdtZK4IknhaTd5W1heiOBENejuiBXRAG27Oq9UImAb4Lu6eNerCwyBUUQElxeO84x2VpKmO++R2dWDjjbQCtTn7gkCg39eoRrOC+/MidOmCKUY8PND50DDjZYoO1uUkLMeCVIVwO6ZlI4lq7gBgdONSGE8oJeAHMAahXcOSDLQKGI9Ql83263iyE5ZXknbOXRaqqcVIsqAbIhrhUVLRRZCoA+8k6PPvBnSylnqug9XkwLlPRtgpQlXy+omEIUtiJErrN9H3MHwuUN72iMp148g0J+ih20S5heJjELqtL4GO/5ZU76ZSiyNbLrVdCFeVBrHPsNoegJVifDe08Cmr1FhYf05KsSR656IKSHQOsO79ul7veCtUQ0WC2jXE+rhvuROqyd0DaF7b20/3eZBVL+/lU4rUmSbUGvBTllTK81y4o0bt4X02Pa1sBPTf59y8HaBkV24Qy9lzYhZ7/e8NIiNCD2meqYstgNhm6fGSe7OLKYk2J98yN0Zs+Md9NDHC9uDwOFNYT50x7cjJoEU4EOHfSfBtc3OpLwwRjPO2v+GhHzuicwZyIeyFRJpUEz1HBu7x1L92Z/MZQxXSQSXZEirXcmBIg4BaGrzZa/DZA+D+cWC0JNs7ScIlPBLynPLZwe10NpQB/POz/A/MiFbF5nMR7/YGVMUAIJyg7ZM+A3X5T2MF/qjQx/3I449H96cqjCyIuXQjNPYdkszSV30Tkv6wJYDgHemJKrhpI0uzCUUNNERXWqAXWXLVSuKYGw+EATna7kqMFDbXuSBitqsA+2rEma8euYs+4jrJQwwR0/+v1vZHjuR2aIYnCs62Ql4wLHg81bXRMdDUlnCzXD1XOXlao5zW/9lpOCBD2jYRf8UP/rDXDqyNOP9NA5zgoJ/aeewl
 sfJImjDk
 QrLOEvzkkUzM1jCl+Zhcacxr6p52RgLLttLx/mFCDBcEdh9auwK2fPPdqiWYOKWchYKCW9IwpYY03vdmgkDeYjfJC5LjhmbUt7m8IiRj/0IrmiU0JXORCcbymguKD8AN6ANAHrhpjYVniXYZCowexKDZWbORNUgXJVFodyPFflHBZIo2Sp6A7I9wG7vGpKOsSj5tE9c4xqIJnNhsO1f0p/gSv15u/Ze+PioIRX9niuN/gzeFVFQUNFBkcwawvq6brGFXzn2vOyhMiLd/bmyhcnSxU4FaRspLvVDQDvkWhxI7g72/3UFgJFympWcre12dkrf8vB9/F4RF54Pqt3uw8RmYee5u1kp8g4YztyRAEIVa3AIIgcSPvbvxl8/hWkO0jRh8aC91L1XQ69tftHSFmEmTOh3ncGDeCtiIZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 04:59, Zi Yan wrote:
> folio_split_supported() used in try_folio_split_to_order() requires
> folio->mapping to be non NULL, but current try_folio_split_to_order() does
> not check it. Add the check to prevent NULL pointer dereference.
> 
> There is no issue in the current code, since try_folio_split_to_order() is
> only used in truncate_inode_partial_folio(), where folio->mapping is not
> NULL.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   include/linux/huge_mm.h | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 1d439de1ca2c..0d55354e3a34 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -407,6 +407,13 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
>   static inline int try_folio_split_to_order(struct folio *folio,
>   		struct page *page, unsigned int new_order)
>   {
> +	/*
> +	 * Folios that just got truncated cannot get split. Signal to the
> +	 * caller that there was a race.
> +	 */
> +	if (!folio_test_anon(folio) && !folio->mapping)
> +		return -EBUSY;
> +
>   	if (!folio_split_supported(folio, new_order, SPLIT_TYPE_NON_UNIFORM, /* warns= */ false))
>   		return split_huge_page_to_order(&folio->page, new_order);
>   	return folio_split(folio, new_order, page, NULL);

I guess we'll take the one from Wei

https://lkml.kernel.org/r/20251119235302.24773-1-richard.weiyang@gmail.com

right?

-- 
Cheers

David

