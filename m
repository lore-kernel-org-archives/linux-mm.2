Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADEA7C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:18:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD5766B00A9; Tue, 15 Sep 2026 08:18:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAC996B00AA; Tue, 15 Sep 2026 08:18:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF1866B00AB; Tue, 15 Sep 2026 08:18:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C0996B00A9
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:18:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 109BF1603BB
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:18:06 +0000 (UTC)
X-FDA: 85215898572.13.3F85FDE
Received: from mta0.migadu.com (out-98.mta0.migadu.com [91.218.175.98])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3B86E1C0007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:18:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jkrzr2Ct;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.98 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jkrzr2Ct;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.98 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789474684;
	b=Be9PswG4WlgY3O7TrDHaRlhouZCcVObT+6cTlGlsavQKKSLxKvK0fttfymQ7wW8v0XaOgY
	q8kt5JchwawS8BMzlqY7mwViPT7E38MrfXJLM9Gt4owyY+nh2mg+phiAUwG5cjYH9hiVG5
	6s4sbBgnb01UpPW3KBk9lpLwB+277Ig=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789474684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ktqcdspGeo8JUkm8ypE4bhTbtnZCEH07bgSeb1FDIU=;
	b=qcD+pIth+P4S1JTtK4jNAz1YxA7+WSLwS2hHx68iBT5kdJ9Do2jQXDgMmkquJrLd69shaZ
	DFReYlkKxRz2pr+wnEj/xIkT3ITUahND170j5IgZakup3YqnPFlV7PiJrhaC97o6UbfzKu
	/mm7n4CQ7rebiWtfEVm3A/R4Q0TdDuQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GQTQIcjs3xXmO+tF4fxaAvvvMtiV7CoLFztx3MvEqf0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789474679; v=1; x=1790079479;
 b=Jkrzr2CtACjyRbHVfuXfeF1Go6n1slEuAExFdiQqAzvkxJcRp9mUDUpL58luR8+bfipFzWA0
 aNJh//Z2vm2fgaTVAKMV6oPHQJCqgaoTMwJUiSgLjJC/kjpsNkc0swc3kE/AFffV+yJAPi/gBeY
 VL5k2VKbTh3pY+HAwWBB7ppQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f5a27be91f52e8fd;
	Tue, 15 Sep 2026 12:17:58 +0000
X-Mizu-Trace-ID: f5a27be91f52e8fd
X-Migadu-Flow: FLOW_OUT
Message-ID: <e38f2b80-20f2-4787-9e07-fb601552f550@linux.dev>
Date: Tue, 15 Sep 2026 20:17:51 +0800
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
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <aqkoeJvFzqpoGeaP@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3B86E1C0007
X-Stat-Signature: 5myah1i3hncwpcw8y6p5mr8fpj9i4aof
X-Rspamd-Server: rspam01
X-HE-Tag: 1789474682-915861
X-HE-Meta: U2FsdGVkX1+wt1e8I9QdMP3VsDEmgimXYUyJe9YCt8wADX05GmdVozPfVZ0GHxVDpWSSlSResqy0jq2HVGwOVsoFH4GlMkt7rA6p3EgCoxpyMU+RNpB506N9MVKW28PNgqyw29A7oA/pQE+eFLXmtty1MLFnbLRP38jjVwwjw4+OaOPNz+n8/mVrc4tTM+3cMxayFDjmyKnRM0WFNiq6pj2MqKbBnEJn+W5x/CdDnKrHFH00YdlL2Rhc92s/LePqCh+RGFLvj/lJypHzHN3qrzwuszlDUSx/P2X71riNDMo8hmvElA5c7HoVMYSSmRUV+lBqiWCRAs8TktIk7nmQ4qQibCJAa2qavHfhZi+q4hWQTQbG8rP618ZpdinxAOe66sOMif+jrLz0ZDtOu2K5aOeaChw7KNdtbCbeCAE4LekozueEdU14OkxT5yLBQCoFbSYrQAQGYsrVTmVuW9qD8PnyaREMmlaZ6WIGHI0XKoqZumWoFa+bMkaa3FwAOPCWsSMkIKRiGRP++42Du1K9/he63KsveNpHBwuIZNqowkrDEQ10Y0HUEWhsruxuCNBteYE5qUwUdDbbBddJc3PvOoyLQSOCqr1htGfmLlr1wJV0yWEWn0YSLn5VcACJxfX7I6VbHiDiWIDhEqogEnMHkoRCk77kMspsp22Npus4VPfaZYMXHXRKQS2Wg8UnPCu1VsY/cjHKt1uWa6A47qCuxTG0YE0VhnMdn2uX+ct4otOfjyGYVU8Nn8+t1Kkftg/Cp9dUzdvMud9JlGVvZ1MCsJwg8J2c9M/ZZHeSeZggKkt6wJ+SZleSt/wFPCttS0kB6MZSOfR9mJzHdILyyWFU6ROtM3K9Gb1ZHIEE3zOvBer8q39xImYUOUSidQVGPNq4m2RSpf9MvykAswu4387R9070sbCQX1aFnxgLvlGOpv0qCXkO0bshraOYjdtJsG+0nbrENt3MOFwe7MSH8SB
 ZbqRsFse
 dtbHjN6mG9Qaz1yXoTld9smbTmDGbU1tLeSWXDZaMALbb868dOpIW+aE7OGv8FXg7nTXBRCbF8H8OsJ71X66CPhjmfgkgDQRsQQOqU4pyxZx4VmQ3wSiNlX4bpNf0dS8FmPXb1skRPLHYjcWFj2BCt7qPLJmV3BI+/WIQqoYNFl3oegpC//garzS+TPAOCXfLt+1MMxUhCA2CMHb2tNFC8iwzCcIuuIyQYSQ40t8DVCoJ5eezZKkMDqGru5xQzy4J09MBHOw9VSb/0b/bUmqlyjV9lbvlYozTwakTusgQNJa8mj47YbnTw8Wvs+9vdQgpv77RsZs57yZvK79Wo6V+tFpUOtGMK/Hu+Izx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/15/2026 7:14 PM, Baoquan He wrote:
> On 09/11/26 at 06:29pm, Ridong Chen wrote:
>> From: Ridong Chen <chenridong@xiaomi.com>
> ...snip...
>> ---
>>   include/trace/events/vmscan.h | 63 +++++++++++++++++++++++++++++++++++
>>   mm/vmscan.c                   |  6 ++++
>>   2 files changed, 69 insertions(+)
>>
>> diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
>> index 8a872990b4be..5defa8f6719c 100644
>> --- a/include/trace/events/vmscan.h
>> +++ b/include/trace/events/vmscan.h
>> @@ -392,6 +392,69 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
>>   		__print_symbolic(__entry->lru, LRU_NAMES))
>>   );
>>   
>> +TRACE_EVENT(mm_mglru_scan_folios,
>> +
>> +	TP_PROTO(struct lruvec *lruvec,
>> +		int highest_zoneidx,
>> +		int order,
>> +		unsigned long nr_requested,
>> +		unsigned long nr_scanned,
>> +		unsigned long nr_sorted,
>> +		unsigned long nr_skipped,
>> +		unsigned long nr_taken,
>> +		int lru,
>> +		unsigned long max_seq,
>> +		int tier,
>> +		unsigned long min_seq),
> 

Thank you for your review.

> Do we need show nid? Guess phone vendor doesn't care about multi-NUMA
> system.
> 

Eh, nid is not an mglru-specific key. Since there are 12 elements here, it can't 
be added here.


> And I checked v1 thread, seems Steven suggested to move the two int to
> avoid extra padding.
> 

Yeah, I will update it. I updated v2 to fix Sashiko's issue, before Steven had 
any comment.


>> +
>> +	TP_ARGS(lruvec, highest_zoneidx, order, nr_requested, nr_scanned,
>> +		nr_sorted, nr_skipped, nr_taken, lru, max_seq, tier, min_seq),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(u64, memcg_id)
>> +		__field(int, highest_zoneidx)
>> +		__field(int, order)
>> +		__field(unsigned long, nr_requested)
>> +		__field(unsigned long, nr_scanned)
>> +		__field(unsigned long, nr_sorted)
>> +		__field(unsigned long, nr_skipped)
>> +		__field(unsigned long, nr_taken)
>> +		__field(int, lru)
>> +		__field(unsigned long, max_seq)
>> +		__field(int, tier)
>> +		__field(unsigned long, min_seq)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
>> +		__entry->highest_zoneidx = highest_zoneidx;
>> +		__entry->order = order;
>> +		__entry->nr_requested = nr_requested;
>> +		__entry->nr_scanned = nr_scanned;
>> +		__entry->nr_sorted = nr_sorted;
>> +		__entry->nr_skipped = nr_skipped;
>> +		__entry->nr_taken = nr_taken;
>> +		__entry->lru = lru;
>> +		__entry->max_seq = max_seq;
>> +		__entry->tier = tier;
>> +		__entry->min_seq = min_seq;
>> +	),
>> +
>> +	TP_printk("memcg_id=%llu classzone=%d order=%d nr_requested=%lu nr_scanned=%lu nr_sorted=%lu nr_skipped=%lu nr_taken=%lu lru=%s max_seq=%lu tier=%d min_seq=%lu",
>> +		__entry->memcg_id,
>> +		__entry->highest_zoneidx,
>> +		__entry->order,
>> +		__entry->nr_requested,
>> +		__entry->nr_scanned,
>> +		__entry->nr_sorted,
>> +		__entry->nr_skipped,
>> +		__entry->nr_taken,
>> +		__print_symbolic(__entry->lru, LRU_NAMES),
>> +		__entry->max_seq,
>> +		__entry->tier,
>> +		__entry->min_seq)
>> +);
>> +
>>   TRACE_EVENT(mm_vmscan_write_folio,
>>   
>>   	TP_PROTO(struct folio *folio),
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 2554a6513aa8..67f59aa73fb9 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -4876,6 +4876,12 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>   	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
>>   				scanned, skipped, isolated,
>>   				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>> +	trace_mm_mglru_scan_folios(lruvec,
>> +				   sc->reclaim_idx, sc->order, nr_to_scan,
>> +				   scanned, sorted, skipped, isolated,
>> +				   type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON,
>> +				   lrugen->max_seq, tier,
>> +				   lrugen->min_seq[type]);
> 
> And seems Steven also suggested to calculate lru, max_seq, min_seq in
> TP_fast_assign() in v1 which could be missed.
> 

Thanks, I will update it following Steven's suggestions.


>          TP_fast_assign(
>                  __entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
>                  __entry->highest_zoneidx = sc->reclaim_idx;
>                  __entry->order = sc->order;
>                  __entry->nr_requested = nr_requested;
>                  __entry->nr_scanned = nr_scanned;
>                  __entry->nr_sorted = nr_sorted;
>                  __entry->nr_skipped = nr_skipped;
>                  __entry->nr_taken = nr_taken;
>                  __entry->lru = type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON;
>                  __entry->max_seq = lrugen->max_seq;
>                  __entry->tier = tier;
>                  __entry->min_seq = lrugen->min_seq;
>          ),
> 

However, 'sc' is an internal structure, so sc->order cannot be accessed in 
TP_fast_assign(), and I don't think it is worth making scan_control an external 
structure just for this.

> 
>>   
>>   	*isolatedp = isolated;
>>   	return scanned;
>> -- 
>> 2.34.1
>>

-- 
Best regards
Ridong


