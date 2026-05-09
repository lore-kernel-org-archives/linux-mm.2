Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CF25CD3447
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 05:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53A166B02F6; Sat,  9 May 2026 01:56:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 511F56B02F7; Sat,  9 May 2026 01:56:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 427906B02F8; Sat,  9 May 2026 01:56:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 314316B02F6
	for <linux-mm@kvack.org>; Sat,  9 May 2026 01:56:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B0B8C140501
	for <linux-mm@kvack.org>; Sat,  9 May 2026 05:56:32 +0000 (UTC)
X-FDA: 84746821824.04.5FC64B5
Received: from mail-pj1-f66.google.com (mail-pj1-f66.google.com [209.85.216.66])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9A85FA0007
	for <linux-mm@kvack.org>; Sat,  9 May 2026 05:56:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="AiKnJs/M";
	spf=pass (imf25.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.216.66 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778306190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oMVyy/IaM9CfR7aJopsUJkLNBd+P1jAwfTc6GxmGXeU=;
	b=Bgc41gqm6tlXwltm7psxRZeQlGWVQiyP1gRvckhNWEKUMQQzP6xIvqbZkYGYWcbYonxjnD
	9/RNqUcLNF1QR0Mu0ValWQsAXDDegiAggjvQ3EOdxTr5k57QVgg64jU5kEtQHvReWB8612
	md9GP54GWsdXpUgSbz3NLVstSzhKwPU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="AiKnJs/M";
	spf=pass (imf25.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.216.66 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778306190; a=rsa-sha256;
	cv=none;
	b=TDKshou5esQdicD/CzH045Eh/xViPFP6K8jO/KbPrKjbu7aQsXsvg/3J5hncGD8wOjF3yt
	e3vWVlcsJ5Aj5OSG6d/2yQ18y7Mq4ABGsVp6zjlspqWf4ZRig7GGCpnalGn8QA3iWDOh7K
	tFhoTAKjD4aAWL6eodpT/T4gMUkhXfI=
Received: by mail-pj1-f66.google.com with SMTP id 98e67ed59e1d1-365d4d2f9c1so1779728a91.1
        for <linux-mm@kvack.org>; Fri, 08 May 2026 22:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778306189; x=1778910989; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oMVyy/IaM9CfR7aJopsUJkLNBd+P1jAwfTc6GxmGXeU=;
        b=AiKnJs/MqaJoi6VT9K7FDO5UbraDQ8x2BDqiA6nuOu5s4jg95T+Bi6lUq7yTfF6oUU
         qPSvG//BywN1awQeUa03jnaZjNJr9S6DxywgpMj5NUz9e9LHqRtPvyDND7dADk8m6U0j
         oyBzGt0U1tdDhTBb6Mw94sEznUdVNx8RngTrgsyBlsuUubjqYSNiUxC9JHNqsC1NiTkU
         suq8xmfQvMKA+0Aui1wxFHlBRIi3OatqkBYbG3rjicxK9kGa6e/m0PkLL4dvAXw6cbrq
         QpOdEm8ycfo1KScGdHlFfdxSSERouPAT6q84MLYLcakpelTUv0dSf7crSHtDcIq02Ezr
         ipkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778306189; x=1778910989;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oMVyy/IaM9CfR7aJopsUJkLNBd+P1jAwfTc6GxmGXeU=;
        b=fj1qw0Njo2dPcOZmKa48orD8QZNTujG9mR8m54V8vwLRBM7vcqwxg1PR9hiBxws21u
         BayrlBvsgiRMwEcldA1QrOsVuWufvBbeaoP5B4q0BSaSfAnEwVZzViU+NaK4Og//oIOS
         d8sJ20l5/PYapNBSvocdlue8GjMqAigFfP96r60UERCIIrRI63vmjrPGZZMsl3wp3Eed
         mqxH6T3s72NE6A0whzpMGfCaclNUTiNs0SkwKmowun+4mRERAxBqVx1LAsKx/Grc4Wh1
         yKR3Wb3hdPyTIroi0cKn8buJT4kwEQSo/mddk3Fbr4HP33i0gn+coaIQFifbxXslZuJx
         KDaA==
X-Forwarded-Encrypted: i=1; AFNElJ/00AGRMz0R7a4tXwXlzxqR94vd9t0Sfl6CHvpg25xJ7vqWIOwUC5qwUpf4ot+qnXVxyJVHxY6GSA==@kvack.org
X-Gm-Message-State: AOJu0Ywo5r9e3h0Ny0+XLH/wxLhn6jIcCuW3Xr9+0Z5Oa6wlUqCYJduT
	VpFjsh9VW0v/gihOXQlWuKi7QRBVfR2qtdAt0hrN02WdL1QJObZHlxGn
X-Gm-Gg: Acq92OEdyZJKmeMHUVnDZ82tDm21xDf9u+EbT34snt2Mu96krBkBsl4pCsAa6BMTvrF
	7I62fYE9Y99nwbdGJFyg70v99WBNpBZ2MSPb/kVENvT/6AeR4D3QCvKkDEX+pttXKHng5McMEr7
	iAkFYyn4ttN0rK+lnxaRopgiPxiFkiImD64+3rmKZ5uRlnGCidALRkTDlrz6YboVREmBqw8DUAs
	DE1dyfuFUSRS50iJF+rWbm0H7vLWOTKFUwVLBxmgrIsv4uQ8zJ5Ra9Iwtiri3GrSy1Aj7Z3umx/
	ZyRCiB2Y85jIshtIPQrd0EK1ueAbTxPpCRK8RcAx8xZMRuJ0ydVP0ASxXMHsNO23jWCVS05n3Vr
	95wAvrvDxnj4h3COq9QT1xa3QXO+fYJj+VlBZDmw05HesoCButP/TPjm/cFeqs1KFqW8C1moHGQ
	J8u9+wGH9eRQxFKwCZprmnSlhgm2inVvQ=
X-Received: by 2002:a17:90b:3c8f:b0:359:8e5e:43de with SMTP id 98e67ed59e1d1-365ac47e3ecmr16022750a91.22.1778306189319;
        Fri, 08 May 2026 22:56:29 -0700 (PDT)
Received: from [10.125.112.20] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-367bd392d2fsm1009154a91.0.2026.05.08.22.56.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2026 22:56:28 -0700 (PDT)
Message-ID: <9e20b388-7952-4d3b-93e1-27b3885ba5d3@gmail.com>
Date: Sat, 9 May 2026 13:56:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/khugepaged: fix spurious -EINVAL from sub-PMD
 MADV_COLLAPSE range
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, shuah@kernel.org, zokeefe@google.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
References: <20260507070558.3064142-1-chenwandun@lixiang.com>
 <20260507070558.3064142-2-chenwandun@lixiang.com>
 <9eea2afb-8c35-47eb-b1de-6a08503c9679@kernel.org>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <9eea2afb-8c35-47eb-b1de-6a08503c9679@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: f8jtrq8nx5k1hn8e6shi1upani5syjzz
X-Rspamd-Queue-Id: 9A85FA0007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778306190-579441
X-HE-Meta: U2FsdGVkX1/+QBj5936302BGQqhX7ME5XaAcuUaxvd6KG1gkmzUU39laoJ7ujmF3idNd3YKJpAKb/K2vPsZbRtcmljrzX70iSoY4imHSCVCQJYNYdWpq5XztHafL9GSmjs6TT70BZNAdmQUxqGg1bywpRHMuscKnkcB+Ule/E8JTl0utDsz7H/QwNJDXHWRR8zsTmE6DPZezJBWS6/qJJBzvbTcTvWtNf9J4eo3cO/x+cXJRw58vT2/2A1S6UJ815DoQ+AVQHeaRuEpulR0sA31lOkO7ldLBR9uVOKV2S6A9aszVZIltCqoQDQiVa1RTe7M1Q8/4D67Gjzh/PMJcK1mtevAoZBWYFrXYnPY28b/LCt8WkX0TrMpYJlpNHlHhx4yup/cXM7+/Qa29WaBiDfrfeNSTeY+66WelqLhXbQz2RnabEZbt2dZREqrZAmswb4jJvpczEa51CLKHuwFE5ilI6ombAQzNOjXz4M9fqjCc0aUeBEugsUxatTlH+YxmUv7Xw7OkxiATWGu0tYP+uqMpTY0fuMc5l4HcpQrdsrGIFx42SU3UmGPX5DtbNSqR4/zaNyI1h6N/AKNnIYRqd9MKx/hE0EYytm493AMsxFkIGwo3rbp8KqnEljgcSe+fnDsYyLmde4GOfMXCe3g1eYJI07pb4GJy2LHR82bBhNYHQtNThKcloRWGxMeZpnR1uYGJ0zde7evgsR0qh65e6BdR0Z49HEk80nzWZe3gZmCHQ9NgTqcgUMtU9Eg/kTfvSk6xgN+vDwR71c4cr9XqzZLkU1ZxCnEoU5CoTe4kqJ+c6hjUDG84gBQ3UUg/XkDco0PYM/e9wKjFM8cKvpsyZCjM6hAYPuEl40ebvIeOLCCvTCS73AUCsKmvGW+kl1j0/nebGP+qcXA4xYURe+OUtolSLf9im1EGYaa4fC43HOfsWgH9vuSL+E7OWAKgboqhd//vVvfogATVyUjD++5
 pLTCjx+J
 VOPD25zwCgrS5x1xmXCOeYK2s0ChELswmFkVqES9wQ9CBcJXQWkG3CZg25xa5XlsCHfAIrcx17t58FO2rZUAM0+3ldAMQPndoWMA3OrqLhi80hg4KZ84FLZD7Ere17T1JuHaR+16VGhN3n6p0rZqhsJ4cVs43GYUHCKLPEHh39iMvXfdJnbzmp7XgJkT4YUMhp+1XtLuB/V7edtGWTITeD9cFS+o6OyjTl6vwPnFKrqBqQ5/SKNHlyUBRvMCUBXlcBpDMzIg3M1lHBoKAF3HkQYWokmQoF7mqyKAj0M+3nI5G+oVb8+N7QmtUyY8MM1iW7sf5iA6sNcCw9qR0NWG6wOOpl6Ws3B8Sr88m6fxnfrt0lYLmqiE5B3ndhNSVpuJx/lDsVoRjBLyantu7hJ/xnEcMYT0D1JfwFpQNrgdp5AP1m6KJla8A2zveZWrXeOxs0LDRyvv8mBDLr/D9TY1cu28iPENllI6PFi1tfbFKab5omwtEFMQMobLsHULS/3DHEbXOshsH3HwF83WIYod1AD4YAxDOZQvgpW7tCj3PS8Xc1OxTv9C7dk5tgTaVbfYtOhArZmjR9+7xRk5AANr7kcNhknHm/gPP0nZM60/Yu8nUHRXOhP+/5GLl7r8+ZxvCc4IZDRSBnBu/DtSJNliQNk4y6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/8/26 20:27, David Hildenbrand (Arm) wrote:
> On 5/7/26 09:05, Chen Wandun wrote:
>> madvise_collapse() computes the THP-aligned window:
>>
>>    hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK  /* round up  */
>>    hend   =  end   &  HPAGE_PMD_MASK                    /* round down */
>>
>> Previously this was done after kmalloc_obj(), so problem arose when
>> the range contained no complete PMD-aligned window (hstart >= hend).
>>
>> When hstart > hend, (hend - hstart) wraps unsigned to a huge value, the
>> final comparison fails and -EINVAL is returned instead of 0.  Consider
>> two single-page calls on a 2 MiB-aligned address:
>>
>>      /* hstart == hend == aligned  ->  0 == 0  ->  returns 0 */
>>      madvise(aligned, PAGE_SIZE, MADV_COLLAPSE);
>>
>>      /* hstart = aligned + 2MiB, hend = aligned
>>       * (hend - hstart) wraps unsigned  ->  returns -EINVAL */
>>      madvise(aligned + PAGE_SIZE, PAGE_SIZE, MADV_COLLAPSE);
>>
>> Both calls cover less than one THP and collapse nothing; both should
>> return 0.
> Okay, so we talk about a "userspace is being stupid" scenario.
>
>> In addition, kmalloc_obj(), mmgrab() and lru_add_drain_all() were all
>> called before discovering there was nothing to do, only for the code
>> to kfree() and return immediately after.
> Just a comment as you motivate here why this is suboptimal: we do not care about
> a "userspace is being stupid" scenario being fast.
>
>> Fix both by computing hstart/hend after thp_vma_allowable_order() but
>> before kmalloc_obj(), and returning 0 early when hstart >= hend.
>>
>> Fixes: 7d8faaf15545 ("mm/madvise: introduce MADV_COLLAPSE sync hugepage collapse")
> Fixes: is likely ok, but I don't think we want to treat this as a hotfix or CC
> stable.
Yes, agree, I would drop this Fixes tag in v2 to avoid any confusion.
>
>> Signed-off-by: Chen Wandun <chenwandun@lixiang.com>
>> ---
>>   mm/khugepaged.c | 9 ++++++---
>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index b8452dbdb043..92473d93e837 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2836,6 +2836,12 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>   	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
>>   		return -EINVAL;
>>   
>> +	hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
>> +	hend = end & HPAGE_PMD_MASK;
>> +
>> +	if (hstart >= hend)
>> +		return 0;
>> +
>>   	cc = kmalloc_obj(*cc);
>>   	if (!cc)
>>   		return -ENOMEM;
>> @@ -2845,9 +2851,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>   	mmgrab(mm);
>>   	lru_add_drain_all();
>>   
>> -	hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
>> -	hend = end & HPAGE_PMD_MASK;
>> -
>>   	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>>   		enum scan_result result = SCAN_FAIL;
>>   
> In general, LGTM, but see for conflict:
> https://lore.kernel.org/all/20260409014323.2385982-1-ye.liu@linux.dev/
Thanks for your review, I will fix the conflict and send v2 version.

Best regards,
Wandun
>
>


