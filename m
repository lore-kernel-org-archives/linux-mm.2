Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C023DC56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 13:45:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B993D6B0098; Thu,  6 Aug 2026 09:45:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4E6C6B0099; Thu,  6 Aug 2026 09:45:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A39B56B009B; Thu,  6 Aug 2026 09:45:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7E7516B0098
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:45:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05FBEC0750
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:45:34 +0000 (UTC)
X-FDA: 85070966988.24.5FE48DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 397C0C0008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:45:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eQpFARiz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786023932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jAk1Hr6s5yQyhKhExTE18XybtKCeypABPp+ECDjJHbQ=;
	b=7pAvCkyQiFU9cksJMoWwX293EDTsGeaDoRJZObwCg6yq9Y84gn/NJVvHpLOVNgyF52Vnet
	24oXJkEvQhp+5xtvrlCqMDXTPAbTidBNo/Bq+yhoRtlC4ivKHzqQ/UUJSu4smAry87xs7W
	1yVH1Kt52ViEncMtgQBdwn+b0oRD1os=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eQpFARiz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786023932;
	b=eqihrdmV58v1PFQbvJtxWK0xDFifnpL7bJfFlOvR9aY4439z6aGPf0sDOonLHCM7olXZXs
	QSKtUhTQV22sa/LWoMwHrST8j/35SvOac7N8+0kNZ8OSg7aZ/FwJQ6riJe9HjcPIrcGX22
	hbaRUlMxDAUAkLEGUwOfdb1bOmVE/nk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 81A7B414A9;
	Thu,  6 Aug 2026 13:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4721F000E9;
	Thu,  6 Aug 2026 13:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786023931;
	bh=jAk1Hr6s5yQyhKhExTE18XybtKCeypABPp+ECDjJHbQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eQpFARizBXLOyawJDeTwY/7/bSx37TLPm4JfgEQNEFHdUJxHWtTJ9GeyZj5uaYXuS
	 3VCCxLZMzaGJvI60f6tEPJy4UrBWR0uZP6vYoVa5aQzAYtDIpO6DRSRcQg6z8gGe9I
	 5E8DELbmr4yEp2URNXIS11Hf8ZSJEOexSwHnFHGQrvr4TAaN6rEfHEvCP7Zhhiu1hF
	 xIFddw+EOJwi18jUHIBfhOXdYQ+ERqgGRV/2+Fhn1UMVUprHAtF0Y8WlgP5qNFffTi
	 D2uIcyE2qm/JT74T/RdnouOijb+TqokwIbDfbnCVxjfDDuCH4xM19W0ESbXilm+/PZ
	 eMEJbVARO5SQw==
Message-ID: <9d0d98ea-05bd-43c0-bb36-68aea62cbde8@kernel.org>
Date: Thu, 6 Aug 2026 15:45:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: khugepaged: skip swap tests when no swap
 available
To: Alexander Gordeev <agordeev@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260804125351.1715708-1-agordeev@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260804125351.1715708-1-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: arz48qkne8pui8r9no9po8jusdfasxdg
X-Rspamd-Queue-Id: 397C0C0008
X-HE-Tag: 1786023932-322563
X-HE-Meta: U2FsdGVkX1/ml6GCXi4qAayu9bpcy+i7o/2tPRaeI/lDPrJe4cC1wuV7LmgFA1TA0O1J1LP0NqqB8jnjaOqPcoiSCJuk20RTF85Z1cYdfs9RArt/ufEmGKdcW8EjamCULUwm+f4SIlAri1z66fGYTpU72q89qVkAmznjz9Ukopan8jheY55saEIMYZmY1XbIBXxR4bBK3cZJmSkB1o4VcMZPGzIBTNSLTaBF99v3GaJACILOaSgHBsCVjMaJpKWIpIfSq3Vhi/edXidrFLkHe2cEPjOlYlj9cQL7oyoYjHX3VzCC0w0Y9gIexd6RO9RI/qRBvaAlRl1LZp8ycH1OMFLQUuURnWs2xRMJx748m5xqHxPukysBqOI+GUbc1tSKOWkNrvFRamPYnT9+NFuGBPhrj0wS2xlYBEJZZHNAMPzavShGgLWk7ZoUoYsJ60Zu1/EuXrlCe9OwcaCbIvODgkXNpmSWMSEmgkwuLNX+SkxKZydIr+kpr7xrMVowFMhco7oWUyjO6EzxmX8IV1yoMJ/BYJuVKRv4lFbBHUS6odLQJeUA5zNKUdIkeobErK0V9Gh2wxFRrbA3yQSLrHQi7tCxvI6d1V6SunFBCApjWki1tWXtF+QEPKwYd671o+DmP2uuoxMwB20qr5qIBHPv+nRq/uSI/e8MnnO1ntmtD+O04O7pdN4SJrAx0TyBH1uYPhdoakfU0y4R8p/xTVK6bi1CyKa9MimavvrK2B2creyNMLuQH4Ty1o0+oY7ujm32JM5W0s+dKnzuElcjeO36Vw68ARV9D4VLXr97wwKx55SZRGrHJSJrNTk+/2o0RdNjLRmeJzbOoxgxPfLTg8o30nUOqhITMH9ASXqsC3KCXNzMfncE4eu4VVLpeussjIS+oJlIs52sTw/g2tzZvn88M+X2bAM6jJ8tShQ8iC8ahrP2Rh8PWNVQr9PVKV5H9BugWEYqueCq807dEaGOLMB
 ncHPLZmM
 kyo0x+/IfTltsiYSkJuCeljx7fpNjkfuPoBbBQJVppYf2iOMpp5Xrsq9cfw4czvVD+LKnzDYfECfst9/giNN+STJVkNMDyKnhIXvROUJ7XWsl2lxii/5aMsoerxqsr7gLbU/DtrBxaPWRuE8qag3GNCRXVSr1k1XF/PsYrC/m4wdWAhQv9wRWkOYODIoksOIapans/UDBRumfCbPzwSHn6kSu/tquD8qEnFLcrU9hco75eSzgM0fYthU7xjs45avKsAzjWak8pw1BaWrboD38o3HJ8bdKOexIEIuRbeyVz9oLCotqE00yoeUikJ4nGmiEaZTLrUuyHjXI1mI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/26 14:53, Alexander Gordeev wrote:
> When no swap is configured, swap-related tests fail because
> madvise(MADV_PAGEOUT) does not swap out pages. Add a helper
> function to detect swap availability and skip these tests.

You should mention what the effect of that is.

> 
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> ---
>  tools/testing/selftests/mm/khugepaged.c | 33 +++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 10e8dedcb087..b254baf9e0b7 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -216,6 +216,25 @@ static bool check_swap(void *addr, unsigned long size)
>  	return swap;
>  }
>  
> +static bool is_swap_available(unsigned long size)
> +{
> +	unsigned long swap_total = 0;
> +	char buffer[256];
> +	FILE *fp;
> +
> +	fp = fopen("/proc/meminfo", "r");
> +	if (!fp)
> +		return false;
> +
> +	while (fgets(buffer, sizeof(buffer), fp)) {
> +		if (sscanf(buffer, "SwapTotal: %lu kB", &swap_total) == 1)
> +			break;
> +	}
> +	fclose(fp);
> +
> +	return swap_total >= (size / 1024);
> +}
> +
>  static void *alloc_mapping(int nr)
>  {
>  	void *p;
> @@ -734,6 +753,13 @@ static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_op
>  {
>  	void *p;
>  
> +	if (!is_swap_available(page_size)) {
> +		ksft_print_msg("No swap available...");
> +		skip("Skip");
> +		ksft_test_result_skip("%s\n", __func__);
> +		return;
> +	}
> +
>  	p = ops->setup_area(1);
>  	ops->fault(p, 0, hpage_pmd_size);
>  
> @@ -760,6 +786,13 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
>  	int max_ptes_swap = thp_read_num("khugepaged/max_ptes_swap");
>  	void *p;
>  
> +	if (!is_swap_available((max_ptes_swap + 1) * page_size)) {
> +		ksft_print_msg("No swap available...");
> +		skip("Skip");
> +		ksft_test_result_skip("%s\n", __func__);
> +		return;
> +	}
> +
>  	p = ops->setup_area(1);
>  	ops->fault(p, 0, hpage_pmd_size);
>  

See

https://lore.kernel.org/all/20260715133418.170386-1-jaeyeon.lee.dev@gmail.com/

where I raise that we should rather handle the actual MADV_PAGEOUT errors,
because there can be other reasons why MADV_PAGEOUT just fails.

-- 
Cheers,

David

