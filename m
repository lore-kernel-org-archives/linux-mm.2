Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B8CCA0EDC
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 02:41:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A189900206; Thu, 14 Aug 2025 22:41:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8516A8E0002; Thu, 14 Aug 2025 22:41:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 740EE900206; Thu, 14 Aug 2025 22:41:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62AE68E0002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 22:41:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3BF45118065
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:41:26 +0000 (UTC)
X-FDA: 83777440572.29.4651AFC
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6A5C61C0006
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:41:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mOpxZTSb;
	spf=pass (imf20.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755225684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=waVzgAtOi12GgE5yS/99lkSoGQsnDE3UwmJZtXxGlEI=;
	b=WKsrqEnw220xFklSC+Y1IzEzLIBnopLlJ1ad7xsnCM/1QXKXzWaKx/1BMZtYGZcc8w/REn
	gAAbOgoGosBXWUtVyJqlaSY7CJsKmibkjpadERNwneRSD8gl4+FP5Ft257wK6x0OF+tptj
	OZQwPKLMqNEYAg549vpVWASshSLUsrI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mOpxZTSb;
	spf=pass (imf20.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755225684; a=rsa-sha256;
	cv=none;
	b=1cwxDj1pYz1KQZYAUv027xacOuWkqn9gyrF02MeYqNzY5K1sk/5pOc/29nor98hc0YPDiI
	jIed4DWpbtMwy4GXyTjCNqNAKsJdct0jmVooUPz9MJIGkeuLvnLkg2IQUlZZSwZrWWd71p
	vGc6UtUkJI9CFr2L/PZ7t2bpMC3akSI=
Message-ID: <be1a8882-fb43-4038-a500-01c3e1a6d577@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755225682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=waVzgAtOi12GgE5yS/99lkSoGQsnDE3UwmJZtXxGlEI=;
	b=mOpxZTSbLfxNoXp5e2h13cpSn1859H5ulR05HsjEyQA5K+tfvtP5JtlCf5X2GxoErJr5sE
	OUTgM7JscK5L2uLEBj+jv2FfpktYyHI0SihUTRvqrkjh/S25sfz8qOj+AXqJiqAgD/FM21
	bn0apTMTP65b6yIoSuCGHjV6S3jkVI8=
Date: Fri, 15 Aug 2025 10:41:16 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm/page_alloc: simplify lowmem_reserve max calculation
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@suse.cz>, Ye Liu <liuye@kylinos.cn>,
 Johannes Weiner <hannes@cmpxchg.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250815023500.36893-1-ye.liu@linux.dev>
 <E5434A0E-3125-48C7-BD25-185CDA4D9FAC@nvidia.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <E5434A0E-3125-48C7-BD25-185CDA4D9FAC@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: nbobt5br1wuh5ktnzhah73ra1uj8j44n
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A5C61C0006
X-Rspamd-Server: rspam05
X-HE-Tag: 1755225684-536618
X-HE-Meta: U2FsdGVkX19DQg8TObDYqG2cN/oo8KsHeQOcD7BoVoQDcGPfanptAo16G67Uu4uvRhwt2RfKo3ykjjpudGhjQhJOEglJePsl9kqJXx5gt5pTAOaQhIgRwq9RbKRaCEP5wIm2ELbWqYVy4sPr5PtYyONhRGlXqb44xxULfYQvSsKImHK4YM8VRe9odx6dXCxo6r9cBV6olzjn/inYQfA+V0rZM+E7ccOJm7+Q0Jup87+pQY38WxXfHNx4wrVykzmsDjBlhPqeODLOnd2JNeHTRp0B5je3rSzNiIlNalJDo+B3XkBV49wAq9ra3wmf7iYj6yMtvqOcHuR6hashR5kdZoiV0Ml8GU5cvxqEkAMetwXRLmbbvEKahI5GAyQkbatEUU0JXt7VUr1SuozCP+rTDlL34dRhYVShpTg/3e5yIAdBS6ypEC4X9WdeF1HaYcTLQ69ioivmeYrATPGNSzcjtQyXgdFfQB3pV0lLXEezuNl8Jfx33Uj6SpOMIS7blXyuNByDYanV7HKyxMuD7kbRUJUUrQgMstd3g0o7vZC6opVtiSTn9zvLRWo+T6cDhz04n8QuDxuKDmmAc8IVNEACS7z+dbnLSHJPhOpgywtgZXUJ8zFLfRFI/c6mqz4plXG463J2mpJXsaAd7fmGtx1OVhvNaLCJjpyt3ww7KI0Sy+dzWfiELdpohHMBLLK3K4cLTxDR2jB6XN+LRar9sd5KevjqjRcBQgvS6gL5wqLIy+vzRmapX/Fl4zCbTNv4Y22qp2AyB12d1GykZzEKf07PrIeXl38gDdSkEjxrUmGLcH0DxOhUn8qObMbftOHS1COiE1HJK90yNK+uzBOg13LjKN4zEKKIolEeTeh0wOMRuO4mJIYCbvddqfCV6Ew4LbhxrQ1PNIVKciCG4pSm6ZJAMPx/9saCGivjmNjUk1V4RsteID/UDNPAbLYD3ZzKsT9aI1QraoRGeb+x6e5UfRc
 qiGXMLla
 MCNMnPK1AHkbS2y8FrWhhjMBuLZbHNgff5+4HUTlt039H0uMSZNjM40ata/dQX/HM/b5d4TplEHKQ6ML64vAs6xSE32ane8TWmkjE1DK64eTHT0WPKQzYnICDVAv7PTXvBEYRPWYRLfCw/IKbbMXY6PuEJQ1e0o5PjbFSCpVAxu2tlHM317dVTtbXDV9eQij0k7j81wrz7XPIXiL/R4clYNDWE0B8F2NWtBs8QV6kW8ZpW+comU5BZt1mLrbl3m4zRkP0DnixONANvRoSbbB3cABJkx4iPrwt57ACHXCyBuFhEdxh67Oki/yiIZokJ0+Mzi/+ScT0nFa3C26LbxiMDtMTdKCcqmAW2ckSSKNj6G7G+qm4d15BCcb4fARtEdUqYCuQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/8/15 10:36, Zi Yan 写道:
> On 14 Aug 2025, at 22:34, Ye Liu wrote:
> 
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> Use max() to find the maximum lowmem_reserve value and min_t() to
>> cap it to managed_pages in calculate_totalreserve_pages(), instead
>> of open-coding the comparisons. No functional change.
>>
>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>> Acked-by: Zi Yan <ziy@nvidia.com>
>>
>> Changes in v2:
>> - Drop unnecessary braces
>> - Replace "if (max > managed_pages)" with min_t()
>> - Link to v1:https://lore.kernel.org/all/20250814090053.22241-1-ye.liu@linux.dev/
>> ---
>>  mm/page_alloc.c | 9 +++------
>>  1 file changed, 3 insertions(+), 6 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 64872214bc7d..2617fd2f4b73 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -6235,16 +6235,13 @@ static void calculate_totalreserve_pages(void)
>>  			unsigned long managed_pages = zone_managed_pages(zone);
>>
>>  			/* Find valid and maximum lowmem_reserve in the zone */
>> -			for (j = i; j < MAX_NR_ZONES; j++) {
>> -				if (zone->lowmem_reserve[j] > max)
>> -					max = zone->lowmem_reserve[j];
>> -			}
>> +			for (j = i; j < MAX_NR_ZONES; j++)
>> +				max = max(max, zone->lowmem_reserve[j]);
>>
>>  			/* we treat the high watermark as reserved pages. */
>>  			max += high_wmark_pages(zone);
>>
>> -			if (max > managed_pages)
>> -				max = managed_pages;
>> +			min_t(unsigned long, max, managed_pages);
> 
> Should be
> 
> max = min_t(unsigned long, max, managed_pages);
> 
> ;)

Haha I forgot to git add after I modified it ;)

> 
>>
>>  			pgdat->totalreserve_pages += max;
>>
>> -- 
>> 2.43.0
> 
> 
> Best Regards,
> Yan, Zi

-- 
Thanks,
Ye Liu


