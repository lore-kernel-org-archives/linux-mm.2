Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 074BDCD6E64
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 08:03:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D8A86B0088; Wed,  3 Jun 2026 04:03:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 089666B008A; Wed,  3 Jun 2026 04:03:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBA326B008C; Wed,  3 Jun 2026 04:03:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0B916B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 04:03:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 743BD4025B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:03:10 +0000 (UTC)
X-FDA: 84837860940.04.25FA3A5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id BD71F18000A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:03:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VKj6Rfrg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780473788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LTJYCksleeQZKtt5TSmRNFAkMP5Na0YE2idGvPI9oDk=;
	b=LvHVGN6s2pkqB0mFMSS2VnC4EynORLBvfOpqBfGGSwGskiCmkVjX9siP/kOVtWKdtQtjFI
	6ot2F7UMWHaKFE8bBzWmF+mV9Fr7oj2zHe3MsuRp7egSVgtgnb7ZPna6VF4IwgEcBp6FVt
	ZH3db36ae0obIrJAeMfjPl/oEZpX0bw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VKj6Rfrg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780473788;
	b=oEsVy+JkLJLePfqgc3JzTD/hZ/GdDVxDxCxjcv86jmIvyELUG6vMzQWmFKNktLFzA5amBW
	FDqZRarHNvSH398h+XNb0D/3QgC7JPXYhSeYfkcrPj8CcdnxvaBSwe2L78JzugkfkLOrtG
	u8p8Q2+je/qeFz14MKgXjxIqOUefyeY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D86360235;
	Wed,  3 Jun 2026 08:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9441F00898;
	Wed,  3 Jun 2026 08:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780473788;
	bh=LTJYCksleeQZKtt5TSmRNFAkMP5Na0YE2idGvPI9oDk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VKj6Rfrgsp6QP0eG7Y3A+lrDbhLZF4gwVt/aPAAjjvBEnqcEM/PpY+m+gEIyDlqMc
	 jzbk4H6ZNQAcIQ9wSYXBuputJZPcep4pMsKflExIXshMbs5gHH1CVyE/ZJpowNn7U3
	 JW3rHZPfNAa+Tqz/3Ac8PcTcMhIp+oaY9NhAK3nANzSpUb9j3jI6ieisZ5hUy+CD33
	 5713rY047/9h+3YZqKvJgH5yDr96rT8xGCu71YVr1v3jisS1W+iYaRVYz5EPWRjv84
	 8jKogWkE8hAHlvTmgW4S65PWk55R43ihnb8vOQIxo6/FEM6p1OqLvjdh9pDGLxuVrx
	 BgINdphckN48A==
Message-ID: <de8878c6-1cb6-476b-814c-907dec842073@kernel.org>
Date: Wed, 3 Jun 2026 10:02:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/thp: clear deferred split shrinker bits when
 queues drain
To: Lance Yang <lance.yang@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: ljs@kernel.org, shakeel.butt@linux.dev, mhocko@kernel.org,
 david@fromorbit.com, roman.gushchin@linux.dev, muchun.song@linux.dev,
 qi.zheng@linux.dev, yosry.ahmed@linux.dev, ziy@nvidia.com,
 liam@infradead.org, usama.arif@linux.dev, kas@kernel.org, vbabka@kernel.org,
 ryncsn@gmail.com, zaslonko@linux.ibm.com, gor@linux.ibm.com,
 wangkefeng.wang@huawei.com, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, dev.jain@arm.com, npache@redhat.com,
 ryan.roberts@arm.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>
References: <20260602043453.67597-1-lance.yang@linux.dev>
 <20260602133706.d737a82858d1cf89870521b1@linux-foundation.org>
 <f5061a2f-c52a-47c4-855c-82f3967833d6@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <f5061a2f-c52a-47c4-855c-82f3967833d6@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BD71F18000A
X-Rspam-User: 
X-Stat-Signature: rwkabfcw19xwohhhnutytkereqs4tmwr
X-Rspamd-Server: rspam09
X-HE-Tag: 1780473788-99082
X-HE-Meta: U2FsdGVkX186JmfLXf94q9tmxQjtqKTS5JAhjjBTesWKgynlsiexRTsXltuLRbqsHb2co8KRNxMDX1Z+MIvjPrb3OX3IAkEWQp2udB8X9cvqUH+GdAY9qpZ9OlP30YEqRgPqGaf3iJ1/aa6aX0n0WPK/kgBJAgYqcjQPO86ytifH/h0Zz78Bu7T4JXeCdBvHe95ZmjCIGysX6kbUCYfNDVgcvRpGqh13PcE4VLC6zyhxgU7i9dAgVyU0IfF6fN0LiuFzpAXHQ5yLQefluGYc5eaclclpdWGA6878/MF1OFqI1BPvg8e0Obr/G9oIJ4J/+X9e/sH7Fz6l8KcVqsZ6MgFP3yx2XxiMMYOSfwouVbHFC2QqgyvC+iHQVar/FLduxeHDOXYLof23kiXTQVON/UgHpnoLFnRpf4PIcPFPlDOe1qtwswbiAoPxzobIhGLWKcyj9yd+TjHHtQDZhBSmS8/2O+PNNtBLJ9WaCZk5jtX6V3Ne9JMXnUcdiC9GRFuJNtlt+rgujd3A3FSLiP/ZcPgyoxtEWhNl+OtitTIYwX7hpUqS6EaqyZdknBPZ5UFbIBdVrGEaggzn3iRnsCWKuSRFIwKSHwWCzamZZFAWPkHeV0m6ePVMLVPiMMbzQc2tRitev+Ycf1xgf5lssP9aCu8f6Nn6UIZZMHIPZT/SW3tey0aLq2HTZKfDqkEjLIvEq684yRwFQ42y9dzuFW/Qaa/o+U6TVftlWlaBWlGSBFJ7ptLi/FZKzG1292j4DGA+mIt0a/57VHc5mYnIqpa8Kl5XKPY2Ot0Fxs9t02e310GFN8OKxdEfT6Ne3niaPXa6iOpgvkXRCP1Q0BpNMWDUr9XXr0w2P0nzAJPXIHO7+XoePBSfL2XHdv7PXh60QOtA15LXYewqhoLGNcWsNaCnnbm3FjbsZsufJ5aZJdR99HxGFt3/j2q+gmW6Eso2OAbsZwTWRoVwWvI+ctIHix3
 8JY7zzE/
 auW1+D2npIttmSm8zLczPVH5e1is1RjrQtiDp1sbaCPkNLHUS/1OkR2qmeVlzZBPWbcrlb7EH3IbO6NIdi93+x/Blw9ZGG1/UyE8FhJr/qnJUwGVJ34PNz5WsbDDRb/rlGBlpI0ZT2HauqYxd6Dlh/3vQcToqR0sLULY4ByOje/k7Pxedt8TzZ0zmFKBb7zguVhNRuyJglRCiUN6kJe3GNMux+LMR4gJ/uboPxaUBXYXb7dXgJLbMu7KXTFIHRr7WrIWwTq3eTyRqIbEUsG6r0TvPp36lTUqGd5j/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/3/26 04:00, Lance Yang wrote:
> 
> 
> On 2026/6/3 04:37, Andrew Morton wrote:
>> On Tue,  2 Jun 2026 12:34:53 +0800 Lance Yang <lance.yang@linux.dev> wrote:
>>
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> deferred_split_count() returns the raw list_lru count. When the per-memcg,
>>> per-node list is empty, that count is 0.
>>>
>>> That skips scanning, but it does not tell memcg reclaim that the shrinker
>>> is empty. shrink_slab_memcg() only clears the memcg shrinker bit when the
>>> count callback reports SHRINK_EMPTY.
>>>
>>> Return SHRINK_EMPTY for an empty deferred split list, so the bit can be
>>> cleared once the queue has drained.
>>>
>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>> ---
>>>   mm/huge_memory.c | 5 ++++-
>>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 72f6caf0fec6..62d598290c3b 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -4397,7 +4397,10 @@ void deferred_split_folio(struct folio *folio, bool
>>> partially_mapped)
>>>   static unsigned long deferred_split_count(struct shrinker *shrink,
>>>           struct shrink_control *sc)
>>>   {
>>> -    return list_lru_shrink_count(&deferred_split_lru, sc);
>>> +    unsigned long count;
>>> +
>>> +    count = list_lru_shrink_count(&deferred_split_lru, sc);
>>> +    return count ?: SHRINK_EMPTY;
>>>   }
>>>     static bool thp_underused(struct folio *folio)
>>
>> Should this be handled as a fix against hannes's "mm: switch deferred
>> split shrinker to list_lru"?
> 
> Hmm ... I noticed this while looking at Johannes' work, but the
> behavior is older than that ...
> 
> We also discussed the Fixes tag earlier[1] and decided to leave it
> out. There is no missed reclaim, only some extra reclaim work :)

Right, I conclude that this can be a separate patch on top.

-- 
Cheers,

David

