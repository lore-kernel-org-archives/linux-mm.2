Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 620D6CF64A2
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 08:04:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9CF96B0024; Thu, 20 Nov 2025 03:04:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4DB46B0029; Thu, 20 Nov 2025 03:04:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98A516B002B; Thu, 20 Nov 2025 03:04:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 86D6D6B0024
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 03:04:14 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80F615AF70
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:04:10 +0000 (UTC)
X-FDA: 84130247460.07.1C08AFB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1AF4D1C0003
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:04:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763625848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dzcgLcI1XZ+3CCYs/jzlDH0atZsdZjbrLjCCwmpereg=;
	b=c5lcHyuoRaIMvkUfCaHilbzrdkTgnoXE4SuXexCclv5Zoxz6EZrFqPYZgv8Au+gMF0zLtb
	Yiff21jbcNImjuJjDmoxzMtQVsHU1HcMsud7ow+Hke/gg6EVUNUv990I/unsajsyAvgGzm
	3ll3EV98XXAA8qLaU+dS1QSatM0D9R0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763625848; a=rsa-sha256;
	cv=none;
	b=d4PO7BhMMVehnbX6skhM6CObyCPa34yNJtfV3oNk+wZxAyCgD3rih+b8YrI8LR0xmYAnoA
	kSHOENxZKAZ6hdllVuZzImS229kADzmteGVQPvheMi3wAjxodMVK5ih2B7FoyI8LckXmZG
	fV8Mn7XYzUki6jyguCq3lRY2+qTZgsU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5E68A2B;
	Thu, 20 Nov 2025 00:03:59 -0800 (PST)
Received: from [10.164.18.59] (MacBook-Pro.blr.arm.com [10.164.18.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9AD1C3F740;
	Thu, 20 Nov 2025 00:04:01 -0800 (PST)
Message-ID: <6c1d6b80-d290-4110-9a49-53e7404136bc@arm.com>
Date: Thu, 20 Nov 2025 13:33:58 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/2] mm/khugepaged: map dirty/writeback pages failures
 to EAGAIN
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20251120065043.41738-6-shivankg@amd.com>
 <20251120065043.41738-10-shivankg@amd.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251120065043.41738-10-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1AF4D1C0003
X-Stat-Signature: 9ogqmbkaae6zacm16dkses6gpak33484
X-Rspam-User: 
X-HE-Tag: 1763625847-710138
X-HE-Meta: U2FsdGVkX19uM0IxhDi9aTGnkU4Wcgfe4132WBMufb1aJTVmy/zSuwxjzUF4uRPaxSdBGlrrZL3Az4cGxV3xz4craifYVEmHGPtIlpCmCDQ8IdyilxVCe8OBDQTvhe6dJAhF3h3Lsb3br/EbsRKG3eHFJDXwyzq26G1lrmoj+cnHezLTCR2FzFaBkJLkyVcN2SwklnPBscY02dedCGtG3o12b7OLzTAy+CoNIRH55fU3xIOeazyEYkF5PtncCgc23iJH57S+oDY500e9d/Rk1jG7ztD/fefknWX5mpokvYcHpqaoDYThRCoweqEzFpRnnNlpBXIrnqEFRDZtWIJE6VyrafF21zAXw4BO/Qca4CKjWV1BQ1D1RSXAWzJ+dJ2Du1TyfDtlJEBveqoqQhlm1zqqbT+vSrGXeJyIsYBRGTeaYi9f4bVv3o9RPWjZB9bMbiqvXrEoV/0oZgcPtctkNM4WKDl7bSnuVUok3FLZXJVhDfgQwFKsJpcYTQMWtseM4hYQO8Po0IHuLnq3BX8NB6bHVHI2oX8JRAVZVI5daDIkG95+lcU4PA3neVA4G91Bqs0C+OrlOzZbf/m8gNjY06+UcsRIapo+YGLnFcIS/a++eZpcu13YurjuORrVPSgC5FXjYZ7SeEt6gDBJK4Y4+zBYVon0OJP3RRncuXaT+97wUGSZg1LtlHu/YBQOSwJx3+mL0AwvA3AAl+eOtZ9yDVU/thY0NI1AezMd0RFShxWLu2wdNyJPZGJ3w+ZYtcS98BotpdsJa/KOVRamtiOtJRxkc6pRXMW6FwSjya5F4o4lwkYZIPxXHdnjJ9iJ+NiVreJleYSH6x449fYplnQ8LW7cS27FDBTEYELCbf2xRlp89BlyPPY/+YovnG8mNYXejc7HS8JGKb48INbaD103krUKkyWng4CUQKOzJzzFBWtdYISiUrA81oJKAiEbMf2lJsjuW6qoSCg7QVJGix3
 X/8jltxu
 jAnIQ5LrmT1CGyP/Q9y1j7ClIBx58AUYBoZqpPYZ57G3XAM7XrrtQ7nTbHDjswywisr5WIonEtP/rwtDTG6PrM+ertUQB3pUbQuWrHI9ir0W32tzk4BTlf7zZq5H6vVZtpJCo5fxxf6yry81ZVsBiGh9Z3KDPNHTy/Mwe/LrNMBsgW/ji2cgXQvey4Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 20/11/25 12:20 pm, Shivank Garg wrote:
> When collapse_file encounters dirty or writeback pages in file-backed
> mappings, it currently SCAN_FAIL which maps to -EINVAL. This is
> misleading as EINVAL suggests invalid arguments, whereas dirty/writeback
> pages represent transient conditions that may resolve on retry.
>
> Introduce SCAN_PAGE_NOT_CLEAN to cover both dirty and writeback states,
> mapping it to -EAGAIN. For MADV_COLLAPSE, this provides userspace with
> a clear signal that retry may succeed after writeback completes, making
> -EAGAIN semantically correct. For khugepaged, this is harmless as it
> will naturally revisit the range during periodic scans after async
> writeback completes.
>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>   include/trace/events/huge_memory.h | 3 ++-
>   mm/khugepaged.c                    | 8 +++++---
>   2 files changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> index 4cde53b45a85..1caf24b951e1 100644
> --- a/include/trace/events/huge_memory.h
> +++ b/include/trace/events/huge_memory.h
> @@ -37,7 +37,8 @@
>   	EM( SCAN_PAGE_HAS_PRIVATE,	"page_has_private")		\
>   	EM( SCAN_STORE_FAILED,		"store_failed")			\
>   	EM( SCAN_COPY_MC,		"copy_poisoned_page")		\
> -	EMe(SCAN_PAGE_FILLED,		"page_filled")
> +	EM( SCAN_PAGE_FILLED,		"page_filled")			\
> +	EMe(SCAN_PAGE_NOT_CLEAN,	"page_not_clean")
>   
>   #undef EM
>   #undef EMe
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 066a332c76ad..282b413d17e8 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -59,6 +59,7 @@ enum scan_result {
>   	SCAN_STORE_FAILED,
>   	SCAN_COPY_MC,
>   	SCAN_PAGE_FILLED,
> +	SCAN_PAGE_NOT_CLEAN,
>   };
>   
>   #define CREATE_TRACE_POINTS
> @@ -1968,11 +1969,11 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
>   				 */
>   				xas_unlock_irq(&xas);
>   				filemap_flush(mapping);
> -				result = SCAN_FAIL;
> +				result = SCAN_PAGE_NOT_CLEAN;
>   				goto xa_unlocked;
>   			} else if (folio_test_writeback(folio)) {
>   				xas_unlock_irq(&xas);
> -				result = SCAN_FAIL;
> +				result = SCAN_PAGE_NOT_CLEAN;
>   				goto xa_unlocked;
>   			} else if (folio_trylock(folio)) {
>   				folio_get(folio);
> @@ -2019,7 +2020,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
>   			 * folio is dirty because it hasn't been flushed
>   			 * since first write.
>   			 */
> -			result = SCAN_FAIL;
> +			result = SCAN_PAGE_NOT_CLEAN;
>   			goto out_unlock;
>   		}
>   
> @@ -2748,6 +2749,7 @@ static int madvise_collapse_errno(enum scan_result r)
>   	case SCAN_PAGE_LRU:
>   	case SCAN_DEL_PAGE_LRU:
>   	case SCAN_PAGE_FILLED:
> +	case SCAN_PAGE_NOT_CLEAN:
>   		return -EAGAIN;
>   	/*
>   	 * Other: Trying again likely not to succeed / error intrinsic to

SCAN_PAGE_NOT_CLEAN is confusing - NOT_CLEAN literally means dirty, so why not SCAN_PAGE_DIRTY?
Or SCAN_PAGE_DIRTY_OR_UNDER_WRITEBACK? Since folio_test_writeback() is true as a result of
the folio being dirty, maybe just SCAN_PAGE_DIRTY can do.

Reviewed-by: Dev Jain <dev.jain@arm.com>


