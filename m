Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E410C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:56:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A7426B00D2; Tue, 25 Aug 2026 09:56:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 558486B00E1; Tue, 25 Aug 2026 09:56:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 447516B00E2; Tue, 25 Aug 2026 09:56:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1AD9D6B00D2
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:56:16 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8DF3E1A01BB
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:56:15 +0000 (UTC)
X-FDA: 85139941110.04.6FDFCE6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id B4B1FC0004
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:56:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ooeyY7C7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of krzk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=krzk@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787666173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FMK9RB8BHr7FFWJqHW9duwXzfQjY/GK6Lj1xCAYHp5Q=;
	b=zRXMQKvgGBj86ewPE4xujorQgemsBPi4ScMcHndMbKxmYwUUE+5/xThjeXKEntip4rc4AD
	Kcdad1/dpS7LR9Z0oGRN6xNsd5P9KSeSAONkBjjctY1O1AtfhpCWJmVMxb/j90TMMoYyRR
	QvfR6Lzau2M4/cmDHZrekPfEEm5QSYY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ooeyY7C7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of krzk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=krzk@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787666173;
	b=LNJwVkzrS56E2NQf9XBhvKyPoU7dOu8dSvceZBQn5gpWruPAhfr9caLraACUUbx76YC+av
	xPgLh/8CC0ujPS7j+S/NdSeNjpcaz/ltLFgtt5ALhEf1JhF/sY/Q0/285qvjQ1RKIsWw9e
	/BWSJ64p/kXcNVoLWJNnAlpKf8G7I4s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 64E2F601E9;
	Tue, 25 Aug 2026 13:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0A71F00A3A;
	Tue, 25 Aug 2026 13:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787666172;
	bh=FMK9RB8BHr7FFWJqHW9duwXzfQjY/GK6Lj1xCAYHp5Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ooeyY7C7Wy+YNpKjA2xzRnySKqHQGeyZlbDkB4S4jvZJBVaFN2aPfF6a73GXK8j4A
	 hbBC7iaiSbQoXcTQFTcIflyIY5Au6eOqVeMsUuCPe1DE0dSY6EsIMi3f7pQwFDKegI
	 +Icsgu39D8nqhFklbzqRoibaHY7ynIvNy75ys5oijRslY6Y9cdUHuEtBzeh9n8dLCj
	 S2fyYw/sULPat7bu4OQ8fuWvdFBlg3lcArY2ceJVkn9J+goEWcdobH4zjS7HO63K8C
	 WS73BTT8F64SEfZ0Kh8lfhNiUkjGGDi1fWTLbbaJg9T37w1Gd+KGRtc4snyWAWnwhC
	 CJc80O6LyAeKw==
Message-ID: <8969b1c2-360b-4fd0-ab70-eb4a68365f50@kernel.org>
Date: Tue, 25 Aug 2026 15:56:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shrinker: do not hold RCU lock in
 shrinker_debugfs_count_show()
To: Nick Huang <sef1548@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Dave Chinner
 <david@fromorbit.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Zenghui Yu <zenghui.yu@linux.dev>,
 Nhat Pham <nphamcs@gmail.com>
References: <20260610232048.62930-1-shakeel.butt@linux.dev>
 <aoxKKXjs3o6jUanE@nickhuang>
 <041af2b5-9136-4027-b35a-72e5044c63ab@kernel.org>
 <ao2emWNMkthyVXn6@nickhuang>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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
In-Reply-To: <ao2emWNMkthyVXn6@nickhuang>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8ymqb5eb3ijkinf8u7y5b8twtd8twfyp
X-Rspamd-Queue-Id: B4B1FC0004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787666173-644173
X-HE-Meta: U2FsdGVkX1/hgWJRaFThVNtNK93Q7+ymgvWYJb/qzyujKPbE1XoEZzUvf5H0j4aQoWg8GVOyoiWO26Rz8nPgW7IyXRfFp9a749FycGd6yBpXOiZlUYYcTxAwqLotbiQmH8hK4RY+UrlhSSMPYGcB+GcYI9OEIrb9gMULUoV0oUS6c8BiwjYenARLluASCRTKT8asPGo89MzL3AiVHEUtkoWa7CQ5RYT6JCYhnZqTzH3fMeYsyWxSTTgLS4PDyCZszmhDbkekcqzMuT4wbNc7QKrhgnVWaMYKep0Mh++E06GsFmDJAWSG1fJn4/hYhLoxwRqmUT3ljBvpfSb08O4oCkzcmPh4W/6N7FfGZTQSkAL54FhHYJPM1S2EsoS28/ZkXU4MVSRbcEvxLMDALBdLkUw9CxChveVeIt2LPV6zlJ2BpjHMArptrrp6z9SbhA7qYY/MTFef2rzfXv0BKl6ICGd1o0/RJ6jmLa/MQEQfMPX3fsAxUqFVCrwnFr8idFvB2sd/XA7nQ90I7eH5e/ZTGpfcilSms7CiAoG/dvh2INZeAWhrOjJahYLmgZINaxtWoGgjOx/pAKGMti8WHLL3KVt0MN8FJJJDOm2mPNy0zfhEk3x2BbYXZMnwf1ae0PwMmA35w+fr6/XoHVjl6JomDsHuIRHtV2YZlVWIUzmT4qtOoBGBEWTYIbLdN3NYY+xrWcv+EH55Ag/posx02963Vjlat9yhOE0iuM1cNpUUGbaub5FG2Qs+HxkU7xNHDd7HQf20dvozT08viFJ1veus+642dvAWgdK3OXI3S4izpEzvnbIal7nwcG1X/G66gK5bTXOSww6l66BBZq5o89PaGF4o11vI+oTZH1YYC5h3XvVlcWMHXDCen50Z5Ot2zeXpM5jgvR0PSEWf1KPPx/V2+zv8CsOy5kGxlKSUJgLZcoBON/DIWomBl11oC0gggql4M0cyPCKQXYbmzQO2au/
 s5VsnOma
 m1RxPHIlB2QBRDNZGi+hLCq3lC+v3jSTa4pSdUXwqx7gyrEPW0PMdf/SReXlmryG8Qhb8gHBzjz3NR9EJPpO3AjvQN/LySu+xAuoJ/Zc6/ShSE5XcQ3p238UKVcQ/CD9QThwKYrhMUEzJtlXTUfd77ahA4cyjUVkI8u44su7tkmbKU31zwy6pPLNMzSwKctXbU+V5VmubEJqSrSMa8G2deaIzQw0F8nj4yiBu5KdKgS7C57tAuyy7S6FppA78xn6Yi2HdgrFhS2JotnrWqXrWmdRZvsjONjq0XFEI4Ks0Pxuu1KPoHZkRLpo4jJPFMA38xk4ji9BaLQuZqkRSIuAm+wH6J2E325aN69sC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25/08/2026 15:54, Nick Huang wrote:
> On Tue, Aug 25, 2026 at 08:12:09AM +0200, Krzysztof Kozlowski wrote:
>> On 24/08/2026 15:42, Nick Huang wrote:
>>> On Wed, Jun 10, 2026 at 04:20:48PM -0700, Shakeel Butt wrote:
>>>> Reading the debugfs "count" file of a memcg-aware shrinker can sleep
>>>> inside an RCU read-side critical section:
>>>>
>>>>   BUG: sleeping function called from invalid context at kernel/cgroup/rstat.c:421
>>>>   RCU nest depth: 1, expected: 0
>>>>    css_rstat_flush
>>>>    mem_cgroup_flush_stats
>>>>    zswap_shrinker_count
>>>>    shrinker_debugfs_count_show
>>>>
>>>> shrinker_debugfs_count_show() invokes the ->count_objects() callback
>>>> under rcu_read_lock(). The zswap callback flushes memcg stats via
>>>> css_rstat_flush(), which may sleep, so it must not run under RCU.
>>>>
>>>> The RCU lock is not needed here. mem_cgroup_iter() takes RCU internally
>>>> and returns a memcg holding a css reference (dropped on the next
>>>> iteration or by mem_cgroup_iter_break()), so the memcg stays alive
>>>> without it. The shrinker is kept alive by the open debugfs file:
>>>> shrinker_free() removes the debugfs entries via
>>>> debugfs_remove_recursive(), which waits for in-flight readers to drain,
>>>> before call_rcu(..., shrinker_free_rcu_cb). The sibling "scan" handler
>>>> already invokes the sleeping ->scan_objects() callback with no RCU
>>>> section.
>>>>
>>>> Drop the rcu_read_lock()/rcu_read_unlock().
>>>>
>>>> Fixes: 5035ebc644ae ("mm: shrinkers: introduce debugfs interface for memory shrinkers")
>>>> Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
>>>> Closes: https://lore.kernel.org/all/c052a064-cddb-494f-a0d8-f8a10b4b1c4d@linux.dev/
>>>> Suggested-by: Nhat Pham <nphamcs@gmail.com>
>>>> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
>>>> ---
>>>>  mm/shrinker_debug.c | 4 ----
>>>>  1 file changed, 4 deletions(-)
>>>>
>>>> diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
>>>> index affa64437302..cda4e86428c8 100644
>>>> --- a/mm/shrinker_debug.c
>>>> +++ b/mm/shrinker_debug.c
>>>> @@ -57,8 +57,6 @@ static int shrinker_debugfs_count_show(struct seq_file *m, void *v)
>>>>  	if (!count_per_node)
>>>>  		return -ENOMEM;
>>>>  
>>>> -	rcu_read_lock();
>>>> -
>>>>  	memcg_aware = shrinker->flags & SHRINKER_MEMCG_AWARE;
>>>>  
>>>>  	memcg = mem_cgroup_iter(NULL, NULL, NULL);
>>>> @@ -88,8 +86,6 @@ static int shrinker_debugfs_count_show(struct seq_file *m, void *v)
>>>>  		}
>>>>  	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
>>>>  
>>>> -	rcu_read_unlock();
>>>> -
>>>>  	kfree(count_per_node);
>>>>  	return ret;
>>>>  }
>>>> -- 
>>>> 2.53.0-Meta
>>>>
>>> Reviewed-by: Nick Huang <sef1548@gmail.com>
>>
>> Sorry, but what exactly did you review here? In the past you were
>> sending AI slop:
>> https://lore.kernel.org/all/aeNGbNyPxJssnkbO@lucifer/
>>
>> Not even properly following the process.
>> https://lore.kernel.org/all/20260724143408.175870-1-sef1548@gmail.com/
>>
>> https://lore.kernel.org/all/?q=f%3Asef1548%40gmail.com
>>
>> Why suddenly reviewing MM patches?
>>
>> Best regards,
>> Krzysztof
> 
> Hi Krzysztof
> 
> I saw this patch on the mailing list and was interested in the RCU issue, so I looked at the related code.
> I checked that removing the outer RCU read-side critical section doesn't break the memcg lifetime, 
> since mem_cgroup_iter() returns the memcg with a CSS reference held.
> I should have explained what I checked instead of just adding a Reviewed-by.
> Thanks for pointing that out.

After all the maintainers already provided a review...

Best regards,
Krzysztof

