Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAC86C5DF97
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 03:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA31F6B009D; Sun, 23 Aug 2026 23:26:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C53396B009F; Sun, 23 Aug 2026 23:26:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6AAE6B00A0; Sun, 23 Aug 2026 23:26:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 949006B009D
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 23:26:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1AB754041B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:26:44 +0000 (UTC)
X-FDA: 85134725928.07.BD6ACC5
Received: from mta0.migadu.com (out-194.mta0.migadu.com [91.218.175.194])
	by imf10.hostedemail.com (Postfix) with ESMTP id BC35EC0002
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:26:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WxR77WXS;
	spf=pass (imf10.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.194 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787542002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JgD3afvp0nYtMPG4A4yHKS/++6q78xjHhx3U7r7IQtI=;
	b=m6b+RMsUNYMxumdWDAsIL3WHbTM2etotF3KohuctHW0cmR4Er2YPacyQBWSn3n52TlQwIu
	ZNlHY7lK/tlc7eEunmGQ7IKIvCLIvCZqwIVo9rHkdlPR0kmiauHvNumIbyr+3wK+LQBW5V
	e8zeXfepizEqmwTIpi3xe6xEjPTUBP0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WxR77WXS;
	spf=pass (imf10.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.194 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787542002;
	b=QwAsmnKTZaX1A92CG+8Hlv37UBg/lvgkoWadE4O93LMPSKsCeyKLSzy+UCHFZTaafKjvoI
	cE9f6tw7hi30wR6rxBVGIexSigUql3Vz9zutUpVeMVR6NqxoXgphZeZ3CCchORrBQeZENN
	Ok7On9FgkqG/LL/jokD4Ogl6EyvIdvY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MOX0Kef8fkPVgmc1F6WgB5gerRrRmBlU8NrSsDREIvE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787542000; v=1; x=1788146800;
 b=WxR77WXSkt+SDL5wu0Ayd8GKgKs2rnZFdjbgDWG1dio8yYg6r7c+8kjzUXSYOfqxMufvoNzj
 u9y9s6SPq9Yki/Ju+UxCJvzQ1Sy6HZRTdE4yKaizHmEWj+NfmK1h/+BB7UAqAkBMA1lymdpI4mP
 Hm+AzkQCAr8sjPz+JHZyhgQU=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.63.107.123] (14.29.108.92)
	by smtp.migadu.com with ESMTPS id f18e9b341d3c2d76;
	Mon, 24 Aug 2026 03:26:40 +0000
X-Mizu-Trace-ID: f18e9b341d3c2d76
X-Migadu-Flow: FLOW_OUT
Message-ID: <6e17bee1-74b8-4d1e-b94e-54c30e945bc5@linux.dev>
Date: Mon, 24 Aug 2026 11:26:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/4] mm/vmscan: drop the combined limit gate in
 __node_reclaim()
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260821081741.1340277-1-ridong.chen@linux.dev>
 <20260821081741.1340277-4-ridong.chen@linux.dev>
 <aohJdZmJjL1YvqIH@cmpxchg.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <aohJdZmJjL1YvqIH@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BC35EC0002
X-Stat-Signature: 36bcqkpjzwcrwfhhwjbouabdyib873ta
X-Rspam-User: 
X-HE-Tag: 1787542001-485236
X-HE-Meta: U2FsdGVkX19mVdJ4ailOyCXqe5MFj4SfTF65ZftLN0zt7BpCeSlbzIa2n7qRMrfyTNS9ahhoGwaFpVon6IAyxVr0z4Ib21b8V+AJ4NaFjQ3ATYmjZnTMQn+6xw2a9yNvKfr3G0wRpbgdM0N2wKAQEeLmGsW2aHYBYItuijhYH7iSywEp9k6JhgkqRVjz8rV2U0/qxY+lF+ZqR4iBuzhcpwy/d+JWUwDNJnJc1HQ8ynKS6cTEfVFmKBEfBSqWwxy5ub6FZdY7M3Twma1zxiltGuDKon2gP7xE7wdBeeHPt+V5+aMFzMgh/6r/vY1K4/C0kV6JmTZUU3mry34prB8qfGjvh26BoSq0EScFmYpeZh5UoLqdTn+VZhIhaDtMHbHYSuAVyGPQlJqm+9Z0YTP/dOegEBSDexaHBNAUPf+8AhXzebaLn1sDGmu+BSr2iDVO41kG2ROFAN8VxbZtx4IvOwjwMNAt8LpigclUuC0g1Y9+EiMrZZQ5l8jgy0kVbvqMmXtGghw/8szqtCNPa9BHaGrx7iFY3fNPwvISQnDzYoW3Era5+4+xzYAzkLnN/t1LeinojeoVsA73KHY4SneJVNtRot+NMO4Pl+VrkuG3eNPKw3L54F6GZ0rxX97iN/7weJMERlGBe2j5yKVNxIjusulTmbHtIqAK8/FodMPOZ9Pc3Geg23b6Ogintk0mFJiBnNO2rk0C9RH1SMUp6aJZeT0vqlXTQBZe1mtgTPwoW0a1DyTDwx2JhzI1uqV9wfcbK7weGlTJD3+7ZPGHbJGaYC1DgcswHmSNMZcHylKqQ1Wu2+3eLz+zVdEOjH6r9i22u2rJTZCedf4uzZumJtyzLfYHDWsF5g9xoYFSioRs7bXnSpmUGge08aYs9MgV88SMRNrNW36gaihROp8r2LLi/dppB3pCviEJfyqRaM+qdPmO6WPyr+J5TNBLS1DntfCebbC1W/CzOw55A39JwvA
 cvevUY4h
 sDx38bZN6xnAoz+jAqgifqjLmlwtmkX/6Vf0gKmnJmAuzRKRe1FAggSPWL7uvph3bx4o6tuWMmz9Tbjcu2bOWSrlys44ET73qXYS8SAvbprkoxqIafbP240HABuNwF70ZXDSMyAyGuMl6/50sLPsbmucfwYsPhgC2o8cOTw9OIJd07VcrQytFzqJAq7T6SmugmeNkigXWOHJT8nA/O+ywwzLXw9Rjbm9J1QOqaTOkTEZp7bErK8/1NQcySOnbdoPOhUXh8caWGbXonymseGNnnOvBN/iK2vfqQbMXqba7IsDXQsHqLsu+hfG32dKJkpqRW2CEW2gHz+6WdxDwUcCB012/UZ1YGspk374fUjrPkTHU3UgeWziEaAJG+tmoRTxE8090dKPVdMzCf5f2fcJXWQikRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/21/2026 8:49 PM, Johannes Weiner wrote:
> On Fri, Aug 21, 2026 at 04:17:40PM +0800, Ridong Chen wrote:
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> __node_reclaim() only ran shrink_node() when unmapped page cache was
>> over min_unmapped_pages OR reclaimable slab was over min_slab_pages.
>>
>> With slab and file reclaim now gated per type by sc->skip_slab_reclaim and
>> sc->skip_file_reclaim, this combined gate is either redundant or harmful:
>>
>>   - for the NUMA node reclaim caller it is always true, since
>>     node_reclaim() only calls in when at least one limit is exceeded;
>>
>>   - for the per-node proactive reclaim caller (which does not go through
>>     node_reclaim()'s checks) it wrongly suppressed all reclaim -- anon
>>     included -- whenever both page cache and slab happened to sit at or
>>     below their limits, even with plenty of reclaimable anon present.
>>
>> Drop the gate and let the per-type flags decide what to reclaim.  The
>> node reclaim path is unchanged; the proactive path can now reclaim anon
>> as requested.
>>
>> Assisted-by: Claude:claude-opus-4-8
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> 
> Could we go with this patch and table the rest of the series?
> 
> These minimums are specifically for zone_reclaim_mode. I don't know
> who is using that at this point, and it seems the behavior has been
> like that for a while with no practical complaints. So my take is,
> leave it until somebody has a real problem.
> 
> Applying those limits to proactive reclaim, on the other hand, wasn't
> intentional, isn't documented, and can lead to unexpected behavior -
> considering we have non-zero default values on these knobs.
> 
> Since the gate was already redundant for some reason, leaving it in
> node_reclaim() (zone_reclaim_mode) and killing it in __node_reclaim()
> (the path shared with proactive reclaim), like you did here, sounds
> like the best way forward for now to me.
> 
> With an updated changelog to that end,
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 

Thanks. Will update.

>> ---
>>   mm/vmscan.c | 20 ++++++++++----------
>>   1 file changed, 10 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 1e56973ceb73..5a3f67b3ba32 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -7906,16 +7906,16 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
>>   	noreclaim_flag = memalloc_noreclaim_save();
>>   	set_task_reclaim_state(p, &sc->reclaim_state);
>>   
>> -	if (node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages ||
>> -	    node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) > pgdat->min_slab_pages) {
>> -		/*
>> -		 * Free memory by calling shrink node with increasing
>> -		 * priorities until we have enough memory freed.
>> -		 */
>> -		do {
>> -			shrink_node(pgdat, sc);
>> -		} while (sc->nr_reclaimed < nr_pages && --sc->priority >= 0);
>> -	}
>> +	/*
>> +	 * Free memory by calling shrink node with increasing
>> +	 * priorities until we have enough memory freed.
> 
> Might as well drop this comment. It just says what the code does.
> 
>> +	 *
>> +	 * What to reclaim is gated per type by sc->skip_slab_reclaim and
>> +	 * sc->skip_file_reclaim.
>> +	 */
>> +	do {
>> +		shrink_node(pgdat, sc);
>> +	} while (sc->nr_reclaimed < nr_pages && --sc->priority >= 0);
>>   
>>   	set_task_reclaim_state(p, NULL);
>>   	memalloc_noreclaim_restore(noreclaim_flag);

-- 
Best regards
Ridong


