Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99FECC61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 12:53:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8700F6B008A; Wed, 26 Aug 2026 08:53:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F66E6B008C; Wed, 26 Aug 2026 08:53:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E6D96B0092; Wed, 26 Aug 2026 08:53:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 455416B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:53:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CB3C380361
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:53:05 +0000 (UTC)
X-FDA: 85143410730.21.C5D1266
Received: from mta0.migadu.com (out-216.mta0.migadu.com [91.218.175.216])
	by imf17.hostedemail.com (Postfix) with ESMTP id B49DF40005
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:53:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xW6t3YJZ;
	spf=pass (imf17.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.216 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787748784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/EDUV0DaY0LrTs1LlFYWBuabfAo+HP01nBLoNlrL6+E=;
	b=6C7w8WNx3VeVTv8JvD15uPqyENkAmFEEyVzRwBbvUrb4/WSjGmVigjZjIU0c620+DOB1Br
	tBjxV2/GoIQ4k5w4v87gxGIFVb3WU94l/9tOX4uo8zqjKIJQm9I6LLOrS4fqZilsXv5LfH
	1Nq81mw8OzMOqb9Cmn5fQe63A2EE4Wk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787748784;
	b=VOQcHUnNINmwazXMSAKNbHvP2ytfHtFxWBubSqQj19fIVy3eBb4Um8LQG8Nwpbt6I2I/Pv
	0FdrkagLjGt+wwWFbPPxVMSksi7qTwH7pYTMDkT6LWa4z76xRlLtWHb3qnLMF5DI2HL8M3
	28tHCYyIbNUBxZKnHzObxIcggOX3cSo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xW6t3YJZ;
	spf=pass (imf17.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.216 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=04gXcZAwaH85rMaDB7p3nP8mrq3e9lgm0ZaYRKBR9UM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787748781; v=1; x=1788353581;
 b=xW6t3YJZtqKo4kEILViETwX/+8oqAzrhsBMqCKH96dMyrHL2Jf2xv/plZ4k7TtF3bgZPQR5t
 7LfM8ey9/FuIxgl6XzsuUmewwbg5lZ+VBSWHDxZ7uyT2eo95+lhFMWgiNvwiggadGo+ZZZFDYEL
 MnIcnRWBsAFwpE9eC6pyCW6U=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.63.107.123] (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 30d681f86186f6ca;
	Wed, 26 Aug 2026 12:53:01 +0000
X-Mizu-Trace-ID: 30d681f86186f6ca
X-Migadu-Flow: FLOW_OUT
Message-ID: <a718bc24-60ea-4d3d-b1b8-2d1f181fef66@linux.dev>
Date: Wed, 26 Aug 2026 20:52:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] mm/vmscan: honour node reclaim limits per type
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260821081741.1340277-1-ridong.chen@linux.dev>
 <aogMyu5R_DZRqp2J@tiehlicka> <f45848da-9569-453f-b0c0-8aa984e1976d@linux.dev>
 <aogZZsXwCyOXISaw@tiehlicka> <bc9c3de9-17b9-4ba1-8065-3270bb455630@linux.dev>
 <aogwUac-sjfcs7Vi@tiehlicka> <dba83897-9bbb-4a44-9021-8f938bb6a12f@linux.dev>
 <aog0ch0u8BtkR-a1@tiehlicka> <de7d583e-bd9b-464f-9e28-73075c0211a4@linux.dev>
 <aowD7tUUIUbhjJQj@tiehlicka>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <aowD7tUUIUbhjJQj@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B49DF40005
X-Stat-Signature: a8fjwq49zysfn81n6b8nb8btsq5iioy1
X-HE-Tag: 1787748783-492773
X-HE-Meta: U2FsdGVkX1/G1/mhs5WbgPlI3pJ2IN5RFpKeebE4HfOdGRvAO1tG+e4/oDptRfhYp8f0lS2jR3tcsxUcEIUvmo7wVFOjkz9GhheMg1g+wm/5YHePQH/rB7tlvO57/pU+n4UdfeRILsutDZyRqZxgUu3wC7cvi9U15xnXxhRTFwIhJJiS9PMPLBOY2KroeqAVmU9A/iLm2DZwZxIsZ3E5DTt7mQ6PkuRr5TCFzYyRIJDkRjB8Ux/9Ej2mKSLcDD6RSybPYIiTRCe1pUxV5h9hVx3nw0gBiGUGYbouTa6hQcMd6QexqxtlVxbz9MaoczBFFl2NMQf93eorGzKzXyqMJNJD0hXdcMtsH1kkwrrJgD27aCl2t6IG8+HltAa7cjalPWELIH7xuMa77OPYt6OfaRhM1ka9F+YxAtrWQtYrUmk+Dkrp4s3IhXsxZLSaFU8ihnzJ8iXnfH4q0HtXQOSaSsLwD81ZSGgTvae5XRs+qaKhHShmnC+rMf7WQiB7KzsVB7ccL0T6slG4tpIAAgHkbpLCJBnze37qPABIa5RS5P9Fl59dmZem6dJ48pxwb/ObMIyTNsVYZO3HlAiZpyvik5IOQPgOSZd2SPcvgIZ2sWvBbrhTFNnDtOkhs+hu9u0/UAWiQEVT7bu3KuJRKNQjvZTd/J9wi5N0nbc6bUGdBhucJ01IAuWIVb08Y+2uSBKQpn5ugRvOVjfzBxBXKpu+vPEarBdw3kJoAI6uI3o8T5za4xDwqABumnVeYwme3nJh1bGc0ZmFWyBKYmkb+WIA++uAQ+UrWlIpNsnGgb9ZaoLbWc6YAxG2XNE1SvS+CHVfWBbn8xBhdH5KPJw3XCWYAkMXpvtLoOpByqAjOWnXzDPIi/CxrFiBZAVGVIuhsXZw8+MmvstRuElZXJhoe8LPtvGjexN5PpmZ/qLQPwN+kZIHQObDbkytQGbeuUeZmXRFXqMrgovMYR1o2ZNNcBl
 gDgHDeDR
 pLO8wW1IFocIGT9PYLdXdJ3vcd1edx83HMLWdLSIkm3cJ1N1IzOsPlUZ82tzXRC2RzkQxgucha+RrznQkkUrdtq8DPT0IJZX9UB4Ol/iD0J7cqHtrsHyLkVzDvR/L3oYVPk0srn9gZssXfPN8oODcAkM/3ZE5ikm8Vv9vrro8AeOSNCf2IizTxrjQCE+LRPjZmT5Kz/YsEmvaRXHS86QyI/bjUWpSIJpdf47pSh+/PxG/lZSr+jxg4aFZWCiwhSGhhMXVjJfMMO1LVirBThDXGmPeyITQCLN8ei+PajC4MDTlqtg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/24/2026 4:42 PM, Michal Hocko wrote:
> On Mon 24-08-26 11:24:46, Ridong Chen wrote:
>>
>>
>> On 8/21/2026 7:20 PM, Michal Hocko wrote:
>>> On Fri 21-08-26 19:10:45, Ridong Chen wrote:
>>>>>> Did you mean that min_slab_pages and min_unmapped_pages should influence
>>>>>> proactive per-node reclaim?
>>>>>
>>
>> I apologize for being incoherent in my last email, it was after a full day
>> of work. What I wanted to say is that min_slab_pages and min_unmapped_pages
>> should *not* influence proactive per-node reclaim.
>>
>>>>> Nope, exactly opposite
>>>>>
>>>>
>>>> I would really appreciate it if you could clarify this further. Sorry, I'm
>>>> not sure I fully understand what you meant.
>>>
>>> pro-active (userspace triggered) node reclaim should completely ignore
>>> all those historical node_reclaim tunables.
>>
>> Yeah, this matches my understanding. Apologies again for the confusing reply.
>>
>> Since Johannes has acked patch 3, perhaps we can simply remove the
>> conditional check in __node_reclaim and keep the shrink loop as follows:
>>
>> ```
>> @@ -7906,16 +7906,16 @@ static unsigned long __node_reclaim(struct
>> pglist_data *pgdat,
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
> 
> Could you post a stand alone patch with the full description please?

I have just done so. I would appreciate any comments you might have on it.

Link: 
https://lore.kernel.org/linux-mm/20260826124409.35569-1-ridong.chen@linux.dev/T/#u

-- 
Best regards
Ridong


