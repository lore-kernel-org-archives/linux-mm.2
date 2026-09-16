Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64F9FC88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:18:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43EF36B0093; Wed, 16 Sep 2026 08:18:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C046B0095; Wed, 16 Sep 2026 08:18:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3546E6B009B; Wed, 16 Sep 2026 08:18:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 17D196B0093
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:18:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9ABD7406EC
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:18:01 +0000 (UTC)
X-FDA: 85219527162.18.74F9731
Received: from mta0.migadu.com (out-167.mta0.migadu.com [91.218.175.167])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5B07D40009
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:17:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="c25CGZ/2";
	spf=pass (imf04.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.167 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789561079;
	b=bPBA4oBJz4adFzTakI68nc8o/l872yfD3Yx2zCXdBdS5VkhBbq5VP9i8Um3u0/WX53Bsv0
	jmbd9luNH+AzTwjhTUg9hoQZJfDz4PjBtbnoMImTMjdiXfYFUkB39pWDfZvSyOhYOkR582
	LeceWthdQx9xZ9DL44/Q4SDYzzAf4CI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="c25CGZ/2";
	spf=pass (imf04.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.167 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789561079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BorA4xxG4TDiAsQp3Tb4u+iQH6GvNNZv/2kBfZZ1R1g=;
	b=WDuf8caBQwZZSVVWvzbpJKDM8l10HqSmmrO44BFUnEqfGr1MreLPPNpiQEV31NdUz3GDzq
	Fj40aWPt5tjaGj/HiLzTDb84924HMPpyLpNwk86chvwOMU/3LGRdW6RIfVT3h0HOwqHKFJ
	FD1ge2NpYKUNDEJPttNmn4Ft1svnZj4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sGhhbpRXCSZiqq9AwMFqiHAd8QFegqbJzta1OrqUPoA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789561077; v=1; x=1790165877;
 b=c25CGZ/2a9gYO97w3wlEuqufGxCY8YY1R3JrasXSSYkaa0SdoRigNjuXzpjNMzsGBSWDfCLD
 td81QVhFUYbWlcC17XsgF4Y3CLvOdYzNqZY2DvlH/B/4+lRcF9U4NjrD81QUMGvUUf5svLevtpe
 kG4nxik3htx6lDDlhA3UIuYU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6aeebd5c5ba43b2f;
	Wed, 16 Sep 2026 12:17:57 +0000
X-Mizu-Trace-ID: 6aeebd5c5ba43b2f
X-Migadu-Flow: FLOW_OUT
Message-ID: <ce8c2ebf-7eb4-4afc-a007-1cfcec439ede@linux.dev>
Date: Wed, 16 Sep 2026 20:17:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm/mglru: add tracepoint for scan_folios()
To: Baoquan He <baoquan.he@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org,
 "open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260911102939.2485750-1-ridong.chen@linux.dev>
 <20260911102939.2485750-3-ridong.chen@linux.dev> <aqkoeJvFzqpoGeaP@fedora>
 <e38f2b80-20f2-4787-9e07-fb601552f550@linux.dev> <aqn7h3BVCCRFI2TI@fedora>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <aqn7h3BVCCRFI2TI@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5B07D40009
X-Stat-Signature: xbqpnahkapmhhqqpjx41teox88e1zgr6
X-HE-Tag: 1789561079-692017
X-HE-Meta: U2FsdGVkX18YzwMVjpn/7jr0xkaW4gweQV9d8yBagE6srzN2OjaKAv16HQcdT5cO0hxf7kBYPa3eC7USjJt2WyH5nxNC0UzE03XknAW2BbdtdIxaD5HWV4qfpjlI03uCjRqv6YR8EFf7gPI9ynhroivYzC34fTe4TdhlVTfDKjgnLqPv9g3emHdgAyF9bo8g+d5Hnl8Mb7GrrXvOq0kug6HQy3jUOlV81CNOdxcpeXzlE3lvSqU220PeQXT5L1492CF3y04lqKHxPfH9eLMQ447SDMu6IBs1Q9R82lVg6gUKdh/CsrEExd/VF7mbj2elk79ATysPmbIAAb/ntBlcAMs0Bfn7T1t92xdF7lpyUlPTx0kGPfTt6orbHc9zxaiikWin2lB89rrUrum5b5RWioaNO8Ng6V1TjERD8eOYz8OufBNLVy6+DFJ4I79iACmbCWnuL5GFAQ1u6EpOFJRuPrk29olblBw809tP2VVVnEThx1BqTOQ4TwGBJMxUKLyDfr8TkItCYy/qHFrc2ZJasDxKfGyIheYxeHqSnpg/ldUF58HQfOnpa/5BCua4ZrU7fDYdGd5Ctze7qsmAS4aEBwo9PxsdyXsA8Rb9IKVvj9QvtIMHVc+Oa92H+zefPVLMvgCw6eXa++3Mg4KfzXzlQeFu8enCtqYAd2e5CHA7UbdLTSTPhKO8eQk9OftUFM93MfN7N+Jik7GMr5GuEi9tidkri0w8A7A5Tlo1+16KfhrXnAmBZAbPe0nQdwcIFqo2DLoxXqs7PSsq0mYgoQAEn6OKAtAweaMDZxqyvrxd0uRks5vFBGsx1UyVNu08LoZybKhOVDNtnrZTwNumGjT6YTHkkZ/RHkC+pUgI7Z2pHHvlT0rH0zjtZCxV94HwGY47vcSDF1dI1VzvGV41OZGGsbmO5gIFZVFx0TrXoegKBTCmt/JEQpbXXYaxHtS75/fq44rw+HGEO23D2jO3Fhq
 382luD9s
 PTcltE7P9D6wr+cq280OkjTXHkzib/cf2nvcvn1vT3vuTLzKYWK+FGcuo/Ri0y2y2SlWQTCUoJCjEri3SLv8JQ8liF13aWVVTp6FEHx0RzvOFJOntCC/V6zojxrg4GZRHZBdjqWDgG9bL8hilGyfNBcSbiDPYbdZwBoO/Wbd6b9DSzOJDLADwDxLebCQ+tFdXW6QHibiteoaZabmOFm8N+ZJTxbSwGkLAKztblmt5YZJMXFkhQCR2jz5YNtbOwfZySVEZvYzxeP9RKqOYiIirciDJk4+nVvMh/VjWYp0UI/qZBUt1OJ3RqshlpH1HbjGaIlFlYHeHfOy9ofK9+Lnl4dUPiGijMGVbPyE1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/16/2026 10:14 AM, Baoquan He wrote:
> On 09/15/26 at 08:17pm, Ridong Chen wrote:
>>
>>
>> On 9/15/2026 7:14 PM, Baoquan He wrote:
>>> On 09/11/26 at 06:29pm, Ridong Chen wrote:
>>>> From: Ridong Chen <chenridong@xiaomi.com>
>>> ...snip...
>>>> ---
>>>>    include/trace/events/vmscan.h | 63 +++++++++++++++++++++++++++++++++++
>>>>    mm/vmscan.c                   |  6 ++++
>>>>    2 files changed, 69 insertions(+)
>>>>
>>>> diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
>>>> index 8a872990b4be..5defa8f6719c 100644
>>>> --- a/include/trace/events/vmscan.h
>>>> +++ b/include/trace/events/vmscan.h
>>>> @@ -392,6 +392,69 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
>>>>    		__print_symbolic(__entry->lru, LRU_NAMES))
>>>>    );
>>>> +TRACE_EVENT(mm_mglru_scan_folios,
>>>> +
>>>> +	TP_PROTO(struct lruvec *lruvec,
>>>> +		int highest_zoneidx,
>>>> +		int order,
>>>> +		unsigned long nr_requested,
>>>> +		unsigned long nr_scanned,
>>>> +		unsigned long nr_sorted,
>>>> +		unsigned long nr_skipped,
>>>> +		unsigned long nr_taken,
>>>> +		int lru,
>>>> +		unsigned long max_seq,
>>>> +		int tier,
>>>> +		unsigned long min_seq),
>>>
>>
>> Thank you for your review.
>>
>>> Do we need show nid? Guess phone vendor doesn't care about multi-NUMA
>>> system.
>>>
>>
>> Eh, nid is not an mglru-specific key. Since there are 12 elements here, it
>> can't be added here.
> 
> Hmm, we print memcg_id but not nid, it may not be so clear. How do you
> differentiate several lruvec-s on one memcg? I am not very familiar with
> trace mechanism, do we have a element number limit?
> 

Yes, it will fail to compile if there are more than 12 elements.

With AI's help, see

include/trace/bpf_probe.h
```
30 #define __CAST1(a,...) __CAST_TO_U64(a)
  31 #define __CAST2(a,...) __CAST_TO_U64(a), __CAST1(__VA_ARGS__)
  32 #define __CAST3(a,...) __CAST_TO_U64(a), __CAST2(__VA_ARGS__)
  33 #define __CAST4(a,...) __CAST_TO_U64(a), __CAST3(__VA_ARGS__)
  34 #define __CAST5(a,...) __CAST_TO_U64(a), __CAST4(__VA_ARGS__)
  35 #define __CAST6(a,...) __CAST_TO_U64(a), __CAST5(__VA_ARGS__)
  36 #define __CAST7(a,...) __CAST_TO_U64(a), __CAST6(__VA_ARGS__)
  37 #define __CAST8(a,...) __CAST_TO_U64(a), __CAST7(__VA_ARGS__)
  38 #define __CAST9(a,...) __CAST_TO_U64(a), __CAST8(__VA_ARGS__)
  39 #define __CAST10(a,...) __CAST_TO_U64(a), __CAST9(__VA_ARGS__)
  40 #define __CAST11(a,...) __CAST_TO_U64(a), __CAST10(__VA_ARGS__)
  41 #define __CAST12(a,...) __CAST_TO_U64(a), __CAST11(__VA_ARGS__)
/* tracepoints with more than 12 arguments will hit build error */
```

> Imagine I only want to trace this function, now I can see memcg_id,
> zone_idex, while don't know node/lruvec, that's a little pitty. Just my
> personal opinion, I could miss anything.
> 

Yeah, you are right. In my personal experience, I always enable 
trace_mm_vmscan_lru_isolate and trace_mm_vmscan_lru_shrink_inactive, which 
contain node_id. So we can see how the lruvec is scanned and shrunk, and we can 
get node_id from trace_mm_vmscan_lru_shrink_inactive. I am not arguing that this 
is exactly the 'correct' way to use these tracepoints, but I think it is a 
common usage.

I am open to that. If we want to record node_id, we have to remove an element. 
Maybe tier? But I would strongly recommend record memcg_id, we frequently need 
to check the reclaim behavior of a memcg, and most of our scenarios are non-NUMA.

>>
>>
>>> And I checked v1 thread, seems Steven suggested to move the two int to
>>> avoid extra padding.
>>>
>>
>> Yeah, I will update it. I updated v2 to fix Sashiko's issue, before Steven
>> had any comment.
>>
>>
>>>> +
>>>> +	TP_ARGS(lruvec, highest_zoneidx, order, nr_requested, nr_scanned,
>>>> +		nr_sorted, nr_skipped, nr_taken, lru, max_seq, tier, min_seq),
>>>> +
>>>> +	TP_STRUCT__entry(
>>>> +		__field(u64, memcg_id)
>>>> +		__field(int, highest_zoneidx)
>>>> +		__field(int, order)
>>>> +		__field(unsigned long, nr_requested)
>>>> +		__field(unsigned long, nr_scanned)
>>>> +		__field(unsigned long, nr_sorted)
>>>> +		__field(unsigned long, nr_skipped)
>>>> +		__field(unsigned long, nr_taken)
>>>> +		__field(int, lru)
>>>> +		__field(unsigned long, max_seq)
>>>> +		__field(int, tier)
>>>> +		__field(unsigned long, min_seq)
>>>> +	),
>>>> +
>>>> +	TP_fast_assign(
>>>> +		__entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
>>>> +		__entry->highest_zoneidx = highest_zoneidx;
>>>> +		__entry->order = order;
>>>> +		__entry->nr_requested = nr_requested;
>>>> +		__entry->nr_scanned = nr_scanned;
>>>> +		__entry->nr_sorted = nr_sorted;
>>>> +		__entry->nr_skipped = nr_skipped;
>>>> +		__entry->nr_taken = nr_taken;
>>>> +		__entry->lru = lru;
>>>> +		__entry->max_seq = max_seq;
>>>> +		__entry->tier = tier;
>>>> +		__entry->min_seq = min_seq;
>>>> +	),
>>>> +
>>>> +	TP_printk("memcg_id=%llu classzone=%d order=%d nr_requested=%lu nr_scanned=%lu nr_sorted=%lu nr_skipped=%lu nr_taken=%lu lru=%s max_seq=%lu tier=%d min_seq=%lu",
>>>> +		__entry->memcg_id,
>>>> +		__entry->highest_zoneidx,
>>>> +		__entry->order,
>>>> +		__entry->nr_requested,
>>>> +		__entry->nr_scanned,
>>>> +		__entry->nr_sorted,
>>>> +		__entry->nr_skipped,
>>>> +		__entry->nr_taken,
>>>> +		__print_symbolic(__entry->lru, LRU_NAMES),
>>>> +		__entry->max_seq,
>>>> +		__entry->tier,
>>>> +		__entry->min_seq)
>>>> +);
>>>> +
>>>>    TRACE_EVENT(mm_vmscan_write_folio,
>>>>    	TP_PROTO(struct folio *folio),
>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>> index 2554a6513aa8..67f59aa73fb9 100644
>>>> --- a/mm/vmscan.c
>>>> +++ b/mm/vmscan.c
>>>> @@ -4876,6 +4876,12 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>>>    	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
>>>>    				scanned, skipped, isolated,
>>>>    				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>>>> +	trace_mm_mglru_scan_folios(lruvec,
>>>> +				   sc->reclaim_idx, sc->order, nr_to_scan,
>>>> +				   scanned, sorted, skipped, isolated,
>>>> +				   type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON,
>>>> +				   lrugen->max_seq, tier,
>>>> +				   lrugen->min_seq[type]);
>>>
>>> And seems Steven also suggested to calculate lru, max_seq, min_seq in
>>> TP_fast_assign() in v1 which could be missed.
>>>
>>
>> Thanks, I will update it following Steven's suggestions.
>>
>>
>>>           TP_fast_assign(
>>>                   __entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
>>>                   __entry->highest_zoneidx = sc->reclaim_idx;
>>>                   __entry->order = sc->order;
>>>                   __entry->nr_requested = nr_requested;
>>>                   __entry->nr_scanned = nr_scanned;
>>>                   __entry->nr_sorted = nr_sorted;
>>>                   __entry->nr_skipped = nr_skipped;
>>>                   __entry->nr_taken = nr_taken;
>>>                   __entry->lru = type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON;
>>>                   __entry->max_seq = lrugen->max_seq;
>>>                   __entry->tier = tier;
>>>                   __entry->min_seq = lrugen->min_seq;
>>>           ),
>>>
>>
>> However, 'sc' is an internal structure, so sc->order cannot be accessed in
>> TP_fast_assign(), and I don't think it is worth making scan_control an
>> external structure just for this.
> 
> Agree.
> 
>>
>>>
>>>>    	*isolatedp = isolated;
>>>>    	return scanned;
>>>> -- 
>>>> 2.34.1
>>>>
>>
>> -- 
>> Best regards
>> Ridong
>>

-- 
Best regards
Ridong


