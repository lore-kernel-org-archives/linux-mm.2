Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51D8CFD3769
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 15:48:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 731806B008C; Wed, 25 Feb 2026 10:48:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F22C6B0095; Wed, 25 Feb 2026 10:48:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61F676B0096; Wed, 25 Feb 2026 10:48:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E42B6B008C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 10:48:39 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E02D21B718F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:48:38 +0000 (UTC)
X-FDA: 84483411516.02.0DE89CF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id B9DCB4000C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:48:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772034517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/lzvS+REHUbdU2iRg0EwTmTnXu8Ing0j53s1RrWMvfg=;
	b=EgRp7yIPeQapjwHHo/xmoo3Hotx3pC9BRkPuA7DdvIPtueM7oVj+HWtOgTVo3DHXBEloDz
	FXnbK2NVYQhknWupIuGgB+2ZAiA57mB2f90GMmTHnTvMYS6s08gXVSIussBeSlQd5hDczV
	RR1ZTBIP3u9ovoWEJQ2KC2z62AkK2Fo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772034517; a=rsa-sha256;
	cv=none;
	b=yUuftg+WysGYd1xWv9XjpxKHbxXiobpnNNv5h0FzCKgsyg/aVL2hWRohBHC3ZgiabfXlMD
	48jWDrFF9bINN8pP1JPSxAzyWxwrYsvAUTY+0XYGJY4G4jbviNVBWfBeRhtu43CD55sNch
	XPmLJLTST87JbxtxyVAuTb348n76CIg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4C52A165C;
	Wed, 25 Feb 2026 07:48:29 -0800 (PST)
Received: from [10.163.135.208] (unknown [10.163.135.208])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E83C63F62B;
	Wed, 25 Feb 2026 07:48:30 -0800 (PST)
Message-ID: <61fc0cd5-58d0-475b-8dab-a453f12c7faf@arm.com>
Date: Wed, 25 Feb 2026 21:18:27 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Avoid calling folio_page() with an out-of-bounds
 index
To: Matthew Wilcox <willy@infradead.org>
Cc: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org,
 david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 ankur.a.arora@oracle.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260225092628.11687-1-lizhe.67@bytedance.com>
 <cc08424a-22d9-422c-90dd-54893bda1213@arm.com>
 <aZ75ydx-FKaFvygT@casper.infradead.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <aZ75ydx-FKaFvygT@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B9DCB4000C
X-Rspamd-Server: rspam02
X-Stat-Signature: pjqro9o4ri8uygwwb9tpgf7xbrietmft
X-HE-Tag: 1772034516-43708
X-HE-Meta: U2FsdGVkX19MYr/EO1/4RYvMdb50Rhra/oKTfL3+zhhfGTmPc1OdLK+xq9rZS+ZTyfa0JnUZ8CQA29+Mx9/ijc4o/xgMbZ1yve2BPIGqVbPmj0WgvZfCv6mtlt+bN40428qYLO2G0jmUoCkj/fuJyObn7Aib/Dw6sw04ZhRfX1sIPkIjsrtCj9UodWeXPx3qrzQ9x2lSu469wvGnkMHIu+qXnRTVFbu7tfkd1SW2CkmJOxdUD+O5UC4m5mRpXaKr8AQDvB1rugDkxCnEpZlEZwcxx0T4DSLbZ8yY9L2BluGI6+/ahaTP/5KHZcBtCdrmHifyIVQa2DHtxCIOtkclNeQcT7i+bAJlmUO3mZ8uT8SnF0UlAko8SzuoJXnlGTsHk0NLRiv/qL2jQTIoNH3Bz2p/IXNwu6eL/TFcO36QJGK/Uaj7ShZi8YZUey9AatK0EHZ+mPdGcIHmfczsx/uJ9joYm2VbusAozYYENxC8u7uPoHzP/oxI29+gzSTgsMjrSxhzIfG6VHBETRf9etjlCdiQoshBKIr7g21P5Me36zTNNtzwUec7x3CNb6qmjtKTZgzMcxW/OsglFiJiyu3Ii1ViGhtpv/kLcS3T6oh9CA3nxWjmTIAP4KKggxS+YJfwXhNv1jO8CdTn5zLQJ3Fw7xVpaj7Zao9l8IbebUje6n6Mjq64CvPoDVnaj/n5egsODvmcAkDfycZNtECAlnM6qJgzKNdA5eVbZVBg3JGZertMzqGj+XmYxgTdkWCw68glOVlNvAFVRuY8nTSzC71BXot4JaH7twD67mD2lTpvRhTFQQg1jtIyl+K/mAVUDAKIINxyoYDLa6WsPduQk+/34/yf8W6rqze1IUykx6vIYDiITzN8in43drr+Nf5ZL8dmCZOf4/sVSLK2y8FJpIDQVSbQUX6StsFzlHhBddDb6bRc2e3ggD1fHS7P+agdEkGPxlEVlYPPUNW4pArOgrv
 frA+Vqah
 grl3nrN0fQpXy4xxofZHR7jg2+SFNVLiJvDRy4IRzpX3C36R7+TAXMiog6SonnKbfEJyzKzQbqJQz8OOwORxotT8cp5fq+7M2xU9VBprd1OKnXG8jHJWf3qXDTuytyTBo/T70mmI0vrNSPMScGUr71yIFyHrqNISQjqHivJTziHR5v5w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/02/26 7:01 pm, Matthew Wilcox wrote:
> On Wed, Feb 25, 2026 at 03:35:32PM +0530, Dev Jain wrote:
>> On 25/02/26 2:56 pm, Li Zhe wrote:
>>> In folio_zero_user(), the page pointer is calculated via folio_page()
>>> before checking if the number of pages to be cleared is greater than zero.
>>> Furthermore, folio_page() does not verify that the page number lies
>>> within folio.
>>>
>>> When 'addr_hint' is near the end of a large folio, the range 'r[0]'
>>> represents an empty interval. In this scenario, 'nr_pages' will be
>>> calculated as 0 and 'r[0].start' can be an index that is out-of-bounds
>>> for folio_page(). The code unconditionally calls folio_page() on a wrong
>>> index, even though the subsequent clearing logic is correctly skipped.
>>>
>>> While this does not cause a functional bug today, calculating a page
>>> pointer for an out-of-bounds index is logically unsound and fragile. It
>>> could pose a risk for future refactoring or trigger warnings from static
>>> analysis tools.
>>>
>>> To fix this, move the call to folio_page() inside the 'if (nr_pages > 0)'
>>> block. This ensures that the page pointer is only calculated when it is
>>> actually needed for a valid, non-empty range of pages, thus making the code
>>> more robust and logically correct.
>>>
>>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>>> ---
>>
>> Not only the correctness, but even from a perf PoV (folio_zero_user is a
>> hot path) it may make sense to initialize the variable only when required.
> 
> But now calculating 'addr' and 'page' is dependent on calculating
> nr_pages instead of being an independent calculation.  I'd be *VERY*
> wary of saying this is a performance win without actually measuring it.
> CPUs are far more complex than you seem to realise (which is ironic,
> given your employer).
> 
> Now, maybe the compiler is smart enough to realise there isn't a real
> dependency and it can hoist the calculation out of the 'if'.  But then
> what have we achieved with this patch?

I did do a compiler analysis in my head, I should have spelled it out
before R'bing in haste :) My guess was that since the array size is small
(i.e 3) the compiler should unroll the for loop - that should perhaps
generate better code with the patch (the two initializations will be done
inside the branch as opposed to outside).

But your point is that the current code may be CPU friendly (better
instruction parallelism, etc), so we shouldn't speculate without testing
(even my compiler logic may be wrong in reality). Indeed. Thank you for
setting me straight.

> 
> Honestly, I think this patch is worthless and would not include it.
> 
>>
>>
>>>  mm/memory.c | 8 +++++---
>>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index 07778814b4a8..6f8c55d604b5 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -7343,12 +7343,14 @@ void folio_zero_user(struct folio *folio, unsigned long addr_hint)
>>>  	r[0] = DEFINE_RANGE(r[2].end + 1, pg.end);
>>>  
>>>  	for (i = 0; i < ARRAY_SIZE(r); i++) {
>>> -		const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
>>>  		const long nr_pages = (long)range_len(&r[i]);
>>> -		struct page *page = folio_page(folio, r[i].start);
>>>  
>>> -		if (nr_pages > 0)
>>> +		if (nr_pages > 0) {
>>> +			const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
>>> +			struct page *page = folio_page(folio, r[i].start);
>>> +
>>>  			clear_contig_highpages(page, addr, nr_pages);
>>> +		}
>>>  	}
>>>  }
>>>  
>>
>>


