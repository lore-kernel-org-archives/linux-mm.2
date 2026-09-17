Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49C8FC982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 03:12:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DF356B008C; Wed, 16 Sep 2026 23:12:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B7ED6B0092; Wed, 16 Sep 2026 23:12:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEB166B0093; Wed, 16 Sep 2026 23:12:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C958F6B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:12:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 45461401FD
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 03:12:33 +0000 (UTC)
X-FDA: 85221781386.12.90F4927
Received: from mta0.migadu.com (out-146.mta0.migadu.com [91.218.175.146])
	by imf03.hostedemail.com (Postfix) with ESMTP id F330A20008
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 03:12:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tMAkWKCU;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.146 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789614751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z3U6bmJ5+Yj+yys+J8qbjQjQR2bbkF9LRZYoKkhr1qA=;
	b=WAEoipVDZ+UW4eGH3IGQlBhGDfcLfV3+k2RNCwDtL8q2iIV5XqzZOuK67qPZZiVOQE4Dau
	3Sm/DWBi904L1pilOC4mQXKP7GmCECr3+M4YxcPy736KGUnpxB/x+4B23M7YcGT9jiRvNp
	N20f7skXs14MwoowPuFsKU2PibT5YpI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789614751;
	b=0HmKEj0MxQSIn2+74STvK5FDi3xaTRFqv27EnsiWQ/XZkhRu24i188AcXdKT0W4DUV0GN2
	cMqkyzQG0rMKugsvG43tuf915rA3/NNr5Jw/rW3+xL8yN6TUS87hsbA33aXEPEzwMvbCnO
	q3hkO/nkm76WeUGLlbI1v79c140Y2hA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tMAkWKCU;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.146 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=wlXY4hkKJ2x6HeDI5mm83kXFqFN7NEczA5K4T7MCPdQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789614749; v=1; x=1790219549;
 b=tMAkWKCUt6N5v3B44qvr/kBsBKPWmWMFMPbTOfRCgGxQJRNXbElDsVonCQ9mMMT79AsBUW00
 2qlDj2bolZ434QZQOy1rcdXTS+4NTsFHI2hu23YzRISdZEDKIhS3Un6mrTSRxCOytkZnDvy5Aqs
 2dmrgM66A4DzPczBcBV/NkaI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 03f180ae3d787af5;
	Thu, 17 Sep 2026 03:12:29 +0000
X-Mizu-Trace-ID: 03f180ae3d787af5
X-Migadu-Flow: FLOW_OUT
Message-ID: <34ffedaf-8f98-48eb-b3a9-d42f273a261d@linux.dev>
Date: Thu, 17 Sep 2026 11:12:20 +0800
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
 <ce8c2ebf-7eb4-4afc-a007-1cfcec439ede@linux.dev> <aqs9auiVq2EplTha@fedora>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <aqs9auiVq2EplTha@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: hj1txu8gd59jnet87osuimw39q1kqfcp
X-Rspamd-Queue-Id: F330A20008
X-HE-Tag: 1789614750-690292
X-HE-Meta: U2FsdGVkX1/WxTcNoag0GFfiIMA/R4/VQwwA9vJFW0wazHLJS2G0hrCCinCBwrPQM9mzHw+KtfoU3CWjMu8G2PalIfPsVcsqaGFpSanzB1H58qFzKTqVKsv81yMzNy/1n0bJ3JIfhK1+ng4aqjh4n6HVkTlRj7B/V8IaPhdSbpw2eI1o5e/5kOi+t8oNb3+cguVQtt/WJCsplMc2OQjDgDtypI2jcxV+7ghUJY5C9zWfURBG6PkuxPiqWhCXXDLsX0/DsRvunMnnDtyL/BO9QLK7D2rEO/lmWS8ncXrXhVd2HX2xnEkWUOGVzIjF3RpadJMaF81lPyUoEXRk3XloeeNIpv/IOPXk6WX1vR8Er1Ju265r7xUTvKHlfH+piyDfUc9dmfMPZn/5nnc4DMCXN93DKfR69FjSECpNOc5CyVaSZG2SdjE46t4i2jTXKiiGDfv6+Lmcf5YkhUniRl3UFMfEvfybhZz2gF/pUexWBUXDyP2cYBcJp0zjaWbSUJsKiJtlo3RCIDgJBs/hJeDd20yW+/0vJfrlc620M0LMCD7FOV5Obl3JHSkmwsFf2r/pGRBJ/WQL8pUxQwAtkiGqlzFFrW+RLPB9L9Kux4xVHWmpMRZ49PAc05b9PKDj2TGXDy+e9Loewxboztn2wFDX3z59TpJ3+tb0v/abgtAw7HyRTNd48xSmouUSbD+Wj95jYGqP+QjZ3lwlEblgcuhA5onriWi9GjXW0Y6R6HO9nnSOEqN7hk79MlccfwmZmWu5A2MpRmr/dTzD3QpPvqpdMHi4cmIwVRwu/T3igqMxhoMOGX2VDUk3RxihEg7BAyK6tng+IgWPsvpc6kykxQI65+RtpR1tedOC1f0kVwmc7e0GZyhe1u4ATulvZBSG5wMiMw2Sn73/11oaVNUR/HiGzQkxsVUtyAfGT6cbxMU6KwXjN5iko0RWUjBIrU69aSGY7IPGeOGa0Gl34rg29T2
 4v/iqhUk
 Ws/JYEPUrXXPVrkjP4dA71A6Ej58YQ6nFaS9JsDV49mzu9J1c5gywt2az0ngftQAb7rFCqXmKsoPHJ/M7f7sdpUAixdPYozEKvlQcH2iUvv4SPR36f0wNI08R3akCGsUN7dNkLeUiXdHJ3zNlX01nb7Acq3DqAcshjaawS6qfnHu/W7A5Vrc7CAAglqsN8ok7KXqzqjtZZPoNyBtCkI1Eu/AfNDE0/yC+3eeTKZ6B4y0R3evUjx1YksTbaSN3LonfLNzJVe6XqXFKCdq8Mv1MXKHNHiwuiaNidkMlKkoS+qNI+onhtdrROycFllVMt7ctV0E+SXZfqsu9vAlK+ukN6sNUjsLTui8LEUNU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/17/2026 9:07 AM, Baoquan He wrote:
> On 09/16/26 at 08:17pm, Ridong Chen wrote:
>>
>>
>> On 9/16/2026 10:14 AM, Baoquan He wrote:
>>> On 09/15/26 at 08:17pm, Ridong Chen wrote:
>>>>
>>>>
>>>> On 9/15/2026 7:14 PM, Baoquan He wrote:
>>>>> On 09/11/26 at 06:29pm, Ridong Chen wrote:
>>>>>> From: Ridong Chen <chenridong@xiaomi.com>
>>>>> ...snip...
>>>>>> ---
>>>>>>     include/trace/events/vmscan.h | 63 +++++++++++++++++++++++++++++++++++
>>>>>>     mm/vmscan.c                   |  6 ++++
>>>>>>     2 files changed, 69 insertions(+)
>>>>>>
>>>>>> diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
>>>>>> index 8a872990b4be..5defa8f6719c 100644
>>>>>> --- a/include/trace/events/vmscan.h
>>>>>> +++ b/include/trace/events/vmscan.h
>>>>>> @@ -392,6 +392,69 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
>>>>>>     		__print_symbolic(__entry->lru, LRU_NAMES))
>>>>>>     );
>>>>>> +TRACE_EVENT(mm_mglru_scan_folios,
>>>>>> +
>>>>>> +	TP_PROTO(struct lruvec *lruvec,
>>>>>> +		int highest_zoneidx,
>>>>>> +		int order,
>>>>>> +		unsigned long nr_requested,
>>>>>> +		unsigned long nr_scanned,
>>>>>> +		unsigned long nr_sorted,
>>>>>> +		unsigned long nr_skipped,
>>>>>> +		unsigned long nr_taken,
>>>>>> +		int lru,
>>>>>> +		unsigned long max_seq,
>>>>>> +		int tier,
>>>>>> +		unsigned long min_seq),
>>>>>
>>>>
>>>> Thank you for your review.
>>>>
>>>>> Do we need show nid? Guess phone vendor doesn't care about multi-NUMA
>>>>> system.
>>>>>
>>>>
>>>> Eh, nid is not an mglru-specific key. Since there are 12 elements here, it
>>>> can't be added here.
>>>
>>> Hmm, we print memcg_id but not nid, it may not be so clear. How do you
>                                 ^~~~ typo, s/not/no/
> 
>>> differentiate several lruvec-s on one memcg? I am not very familiar with
>>> trace mechanism, do we have a element number limit?
>>>
>>
>> Yes, it will fail to compile if there are more than 12 elements.
>>
>> With AI's help, see
>>
>> include/trace/bpf_probe.h
>> ```
>> 30 #define __CAST1(a,...) __CAST_TO_U64(a)
>>   31 #define __CAST2(a,...) __CAST_TO_U64(a), __CAST1(__VA_ARGS__)
>>   32 #define __CAST3(a,...) __CAST_TO_U64(a), __CAST2(__VA_ARGS__)
>>   33 #define __CAST4(a,...) __CAST_TO_U64(a), __CAST3(__VA_ARGS__)
>>   34 #define __CAST5(a,...) __CAST_TO_U64(a), __CAST4(__VA_ARGS__)
>>   35 #define __CAST6(a,...) __CAST_TO_U64(a), __CAST5(__VA_ARGS__)
>>   36 #define __CAST7(a,...) __CAST_TO_U64(a), __CAST6(__VA_ARGS__)
>>   37 #define __CAST8(a,...) __CAST_TO_U64(a), __CAST7(__VA_ARGS__)
>>   38 #define __CAST9(a,...) __CAST_TO_U64(a), __CAST8(__VA_ARGS__)
>>   39 #define __CAST10(a,...) __CAST_TO_U64(a), __CAST9(__VA_ARGS__)
>>   40 #define __CAST11(a,...) __CAST_TO_U64(a), __CAST10(__VA_ARGS__)
>>   41 #define __CAST12(a,...) __CAST_TO_U64(a), __CAST11(__VA_ARGS__)
>> /* tracepoints with more than 12 arguments will hit build error */
>> ```
>>
>>> Imagine I only want to trace this function, now I can see memcg_id,
>>> zone_idex, while don't know node/lruvec, that's a little pitty. Just my
>>> personal opinion, I could miss anything.
>>>
>>
>> Yeah, you are right. In my personal experience, I always enable
>> trace_mm_vmscan_lru_isolate and trace_mm_vmscan_lru_shrink_inactive, which
>> contain node_id. So we can see how the lruvec is scanned and shrunk, and we
>> can get node_id from trace_mm_vmscan_lru_shrink_inactive. I am not arguing
>> that this is exactly the 'correct' way to use these tracepoints, but I think
>> it is a common usage.
>>
>> I am open to that. If we want to record node_id, we have to remove an
>> element. Maybe tier? But I would strongly recommend record memcg_id, we
>> frequently need to check the reclaim behavior of a memcg, and most of our
> 
> Sorry, that's my typo which could cause misunderstanding. I meant "we print
> memcg_id but no nid, it may not be so clear". I agree with you that
> memcg_id is undispensable.
> 
>> scenarios are non-NUMA.
> 
> Understood, mobile phone mostly is non-NUMA, while server is different.
> About adding nid, I cousulted AI too, it says it's doable.
> 
> It says The 12-argument limit only counts the TP_PROTO arguments (that's
> the BPF __CAST12/bpf_trace_run12 path), not the __entry fields in
> TP_STRUCT__entry. And nid doesn't have to be a 13th argument at all. We
> already pass lruvec, so nid can be derived from it in TP_fast_assign with
> lruvec_pgdat(lruvec)->node_id.
>                                                                                                        
> e.g. for mm_mglru_scan_folios:
>                                                                                                        
>     TP_STRUCT__entry(
>        __field(u64, memcg_id)
>        __field(int, nid)
>        __field(int, highest_zoneidx)
>        __field(int, order)
>        __field(unsigned long, nr_requested)
>        __field(unsigned long, nr_scanned)
>        __field(unsigned long, nr_sorted)
>        __field(unsigned long, nr_skipped)
>        __field(unsigned long, nr_taken)
>        __field(int, lru)
>        __field(unsigned long, max_seq)
>        __field(int, tier)
>        __field(unsigned long, min_seq)
>     ),
>                                                                                                        
>     TP_fast_assign(
>        __entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
>        __entry->nid      = lruvec_pgdat(lruvec)->node_id;
>        __entry->highest_zoneidx = highest_zoneidx;
>        ...
>     ),
>                                                                                                        
>     TP_printk("memcg_id=%llu nid=%d classzone=%d order=%d ...",
>        __entry->memcg_id,
>        __entry->nid,
>        __entry->highest_zoneidx,
>        ...)
>                                                                                                        
> lruvec_pgdat() comes from include/linux/mmzone.h, which vmscan.h already
> pulls in via linux/mm.h, so no extra include is needed. The same pattern
> applies to mm_mglru_inc_max_seq in patch 3 if you want nid there too.
> I didn't try it though, please feel free to give it a shot.
> 

Good. It works, I just tested it. Will add nid.

> 
>>
> 
>>>>
>>>>
>>>>> And I checked v1 thread, seems Steven suggested to move the two int to
>>>>> avoid extra padding.
>>>>>
>>>>
>>>> Yeah, I will update it. I updated v2 to fix Sashiko's issue, before Steven
>>>> had any comment.
>>>>
>>>>
>>>>>> +
>>>>>> +	TP_ARGS(lruvec, highest_zoneidx, order, nr_requested, nr_scanned,
>>>>>> +		nr_sorted, nr_skipped, nr_taken, lru, max_seq, tier, min_seq),
>>>>>> +
>>>>>> +	TP_STRUCT__entry(
>>>>>> +		__field(u64, memcg_id)
>>>>>> +		__field(int, highest_zoneidx)
>>>>>> +		__field(int, order)
>>>>>> +		__field(unsigned long, nr_requested)
>>>>>> +		__field(unsigned long, nr_scanned)
>>>>>> +		__field(unsigned long, nr_sorted)
>>>>>> +		__field(unsigned long, nr_skipped)
>>>>>> +		__field(unsigned long, nr_taken)
>>>>>> +		__field(int, lru)
>>>>>> +		__field(unsigned long, max_seq)
>>>>>> +		__field(int, tier)
>>>>>> +		__field(unsigned long, min_seq)
>>>>>> +	),
>>>>>> +
>>>>>> +	TP_fast_assign(
>>>>>> +		__entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
>>>>>> +		__entry->highest_zoneidx = highest_zoneidx;
>>>>>> +		__entry->order = order;
>>>>>> +		__entry->nr_requested = nr_requested;
>>>>>> +		__entry->nr_scanned = nr_scanned;
>>>>>> +		__entry->nr_sorted = nr_sorted;
>>>>>> +		__entry->nr_skipped = nr_skipped;
>>>>>> +		__entry->nr_taken = nr_taken;
>>>>>> +		__entry->lru = lru;
>>>>>> +		__entry->max_seq = max_seq;
>>>>>> +		__entry->tier = tier;
>>>>>> +		__entry->min_seq = min_seq;
>>>>>> +	),
>>>>>> +
>>>>>> +	TP_printk("memcg_id=%llu classzone=%d order=%d nr_requested=%lu nr_scanned=%lu nr_sorted=%lu nr_skipped=%lu nr_taken=%lu lru=%s max_seq=%lu tier=%d min_seq=%lu",
>>>>>> +		__entry->memcg_id,
>>>>>> +		__entry->highest_zoneidx,
>>>>>> +		__entry->order,
>>>>>> +		__entry->nr_requested,
>>>>>> +		__entry->nr_scanned,
>>>>>> +		__entry->nr_sorted,
>>>>>> +		__entry->nr_skipped,
>>>>>> +		__entry->nr_taken,
>>>>>> +		__print_symbolic(__entry->lru, LRU_NAMES),
>>>>>> +		__entry->max_seq,
>>>>>> +		__entry->tier,
>>>>>> +		__entry->min_seq)
>>>>>> +);
>>>>>> +
>>>>>>     TRACE_EVENT(mm_vmscan_write_folio,
>>>>>>     	TP_PROTO(struct folio *folio),
>>>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>>>> index 2554a6513aa8..67f59aa73fb9 100644
>>>>>> --- a/mm/vmscan.c
>>>>>> +++ b/mm/vmscan.c
>>>>>> @@ -4876,6 +4876,12 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>>>>>     	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
>>>>>>     				scanned, skipped, isolated,
>>>>>>     				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>>>>>> +	trace_mm_mglru_scan_folios(lruvec,
>>>>>> +				   sc->reclaim_idx, sc->order, nr_to_scan,
>>>>>> +				   scanned, sorted, skipped, isolated,
>>>>>> +				   type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON,
>>>>>> +				   lrugen->max_seq, tier,
>>>>>> +				   lrugen->min_seq[type]);
>>>>>
>>>>> And seems Steven also suggested to calculate lru, max_seq, min_seq in
>>>>> TP_fast_assign() in v1 which could be missed.
>>>>>
>>>>
>>>> Thanks, I will update it following Steven's suggestions.
>>>>
>>>>
>>>>>            TP_fast_assign(
>>>>>                    __entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
>>>>>                    __entry->highest_zoneidx = sc->reclaim_idx;
>>>>>                    __entry->order = sc->order;
>>>>>                    __entry->nr_requested = nr_requested;
>>>>>                    __entry->nr_scanned = nr_scanned;
>>>>>                    __entry->nr_sorted = nr_sorted;
>>>>>                    __entry->nr_skipped = nr_skipped;
>>>>>                    __entry->nr_taken = nr_taken;
>>>>>                    __entry->lru = type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON;
>>>>>                    __entry->max_seq = lrugen->max_seq;
>>>>>                    __entry->tier = tier;
>>>>>                    __entry->min_seq = lrugen->min_seq;
>>>>>            ),
>>>>>
>>>>
>>>> However, 'sc' is an internal structure, so sc->order cannot be accessed in
>>>> TP_fast_assign(), and I don't think it is worth making scan_control an
>>>> external structure just for this.
>>>
>>> Agree.
>>>
>>>>
>>>>>
>>>>>>     	*isolatedp = isolated;
>>>>>>     	return scanned;
>>>>>> -- 
>>>>>> 2.34.1
>>>>>>
>>>>
>>>> -- 
>>>> Best regards
>>>> Ridong
>>>>
>>
>> -- 
>> Best regards
>> Ridong
>>

-- 
Best regards
Ridong


