Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B03DC88E56
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 10:25:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 805CF6B0088; Sun, 13 Sep 2026 06:25:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B6D96B008C; Sun, 13 Sep 2026 06:25:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CC656B0092; Sun, 13 Sep 2026 06:25:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45E546B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 06:25:51 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 497ECA4A8A
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 10:25:50 +0000 (UTC)
X-FDA: 85208358060.11.86D4C2B
Received: from mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4C14D1C0003
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 10:25:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w0cdeFZ+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789295148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bTKDsm5YH+VJniy5D6ruwYPjdqO/xcgqca/PoVBtJFM=;
	b=g4B60CBwLBlMlu0f0jZq7TNCOdj7XTxWPKDO5n5TAQvzPSITz2iohtq0x/6OK1GYSkDIqS
	8Sz9IwhAKkL0aNayiTugyWXorUVYDPyM877TMuPOpdPPJ9Xl+fXCcyf5jNnR/1fLv13MUo
	03E1bl0TYf9hVpdQVeNHemNN/RxFOOM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789295148;
	b=r/YxLGMBO4tacHiqxciXisUqVuivcXfy324gKuLvlEB1+pEPCldOdZ65BC6yZ3cPQp965D
	EfXtNq3+QB2l91c1pEt9PynRJw7UJU3oLNgNl6X/r0iFt3d/KhjyplJsWLbQSoW6GnH4iC
	MKaPcjhuALxvLG/+oa5L4VGjVlLcGqY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w0cdeFZ+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RBRi6I3a87/juJLx+fNqZVRPmjDwMN9oEpqOjLUx424=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789295146; v=1; x=1789899946;
 b=w0cdeFZ+8XOD6hCw74SDPrBrIySEC7wind7pLhSxdkWWliAl+pRJbM1vCWK5X76U1ECD+rDT
 uYEWCqc889aCXrmQFsHi+y6Q92zdBUEdCQyylKyR5w1AS3xqneCk2t/2cdwCbLuav6LoanJGc7N
 /z7S46IcHp2uJz7sx8hrzdjo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 211913a8fa41334d;
	Sun, 13 Sep 2026 10:25:46 +0000
X-Mizu-Trace-ID: 211913a8fa41334d
X-Migadu-Flow: FLOW_OUT
Message-ID: <cec74135-b7c6-4405-8e0e-d33564429121@linux.dev>
Date: Sun, 13 Sep 2026 18:25:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm/mglru: add tracepoint for scan_folios()
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org,
 "open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260911072848.2346073-1-ridong.chen@linux.dev>
 <20260911072848.2346073-3-ridong.chen@linux.dev>
 <20260911101120.25e3495a@gandalf.local.home>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260911101120.25e3495a@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4C14D1C0003
X-Stat-Signature: gs4rmam39rypz3zwgo6bfme63xfr86uk
X-HE-Tag: 1789295148-173113
X-HE-Meta: U2FsdGVkX1/01tWmC8nWNDWV3HVnjmTQilj6csm0MSZYXbRnfYpcbOEDGzou1061V24KRACLLhZvxa5yEEcMZnQpZNUC0Ts/c/N2s8POftCK1N+bfy0eOvvq0q6lJZxIri6TtWAzsPxyqSx+30UkSVz2GgRHzoVo0JIMy7lO/tRZj7muGhS8f4tx6NS00jX6k8BlXFQbH+CT21T0nycuo12T7BlKQdl4V3cEWiEwAF6BklNQLwefmEQNCi3ii0cyYQhk/hHSLx7iRL55ObYXvS28b2AxPrbUfija+hfojJVdoEnShGDpeDVGLxMUBiFkggeYJOVpm6SRYDLBQsJ4rDmcTRHI5dWvPOZiRQ0q97V/FCrWNjHw3qH6ex3R8GccI7Nmktye9RLgR5RNAJtzP8dgZqI/YBLi+v6oOJi6ZriOj12v9aXGb9P4EDqNaefz+/u24WStqo5QEF+05AlzpeS7a5ZU00BHisgVGvGxh+r/+R38gy4g8qz4EQDJpUdkJq1VJl84KQNtS5AAsuLSD2viP+/FsXA900gULTjRpqqFQV+f8MnmtW07vOLFYku25dCW3zrlCu7+4qTCXGLpeSetsdRrEPsmJsXHiyMMY8st6EIV0NfYSYwBb+T4H9CZuS1a/PNzZv8rWj/8UFt6t9Y7RwgyO1w7uFk3NbCVAHAO4KQwMjaSE5JYTx/XQpTLfcVPrFSewzduf7SIxdul8ucpco12JKSHWhicJfFc+DrMEPUDyPIDnP7KYseBzv52fRjAq1F2kMJ3X01x+YjaUlE8LnhTWUGKQf8oJTIPnmDVhkAOl6xDxlXFpazOx42nJUPf4xwmGx4kxvHQG/Li/283PWXqsHd3AeM26cZ0eOFZMvksyrQfpmjGSLb6NsnfTL5JLylATSPGl7r9l4o2L4BtwwcZ6IPfYop91cyUaHO6pUc5jjtrui8xNdyJ2RHu1yPlm47RMQ0H6Nfli68
 vQv/5rD0
 LgykePhXvIj4Zi8663cqsTgYicPMzMUNXMBwbC7TWj6XtjCQGZcYQzLroGhOOTDTLbP1Mbmr/DJH3lJQOU+wHNU7CWyMLUtI/qmE/BGoTsG6XMtv/g0526CziiDwN6woU9ti9oo/tLsbWEpenmZye87hufUsIdDV0t7P1iaywRYWRzVzlEc278nTm9AGO5qlEPg5Yc96+O+vIY2BwoqhrY3i9i5meB77C0IOVHTDEeEdApt4Ik/1rsKtNzF0U1n4oI6XZyXQLVZe4yNUGQtQ21IxqjSs9Y70Op6Txs9YUmyror7FcxzilkpKOxx1qsqdD7xFnPuKoXiL3bnHWte8lN9Q9XsvuIz0zM8v3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/11/2026 10:11 PM, Steven Rostedt wrote:
> On Fri, 11 Sep 2026 15:28:47 +0800
> Ridong Chen <ridong.chen@linux.dev> wrote:
> 
>> diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
>> index 8a872990b4be..c39dfacef033 100644
>> --- a/include/trace/events/vmscan.h
>> +++ b/include/trace/events/vmscan.h
>> @@ -392,6 +392,69 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
>>   		__print_symbolic(__entry->lru, LRU_NAMES))
>>   );
>>   
>> +TRACE_EVENT(mm_mglru_scan_folios,
>> +
>> +	TP_PROTO(u64 memcg_id,
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
>> +
>> +	TP_ARGS(memcg_id, highest_zoneidx, order, nr_requested, nr_scanned,
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
> 

Thank you very much for your review.

> Please keep "int"s together. This creates a structure that is used to write
> into the ring buffer. On 64bit machines, the above would add 4 bytes of
> padding after each int, whereas:
> 
> 		__field(unsigned long, max_seq)
> 		__field(unsigned long, min_seq)
> 		__field(int, lru)
> 		__field(int, tier)
> 
> 
> would not.
> 

Will upate.

>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->memcg_id = memcg_id;
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
>> index 2554a6513aa8..bd1b9ecf2e84 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -4876,6 +4876,12 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>   	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
>>   				scanned, skipped, isolated,
>>   				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>> +	trace_mm_mglru_scan_folios(mem_cgroup_id(lruvec_memcg(lruvec)),
>> +				   sc->reclaim_idx, sc->order, nr_to_scan,
>> +				   scanned, sorted, skipped, isolated,
>> +				   type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON,
>> +				   lrugen->max_seq, tier,
>> +				   lrugen->min_seq[type]);
> 
> Can't this information be processed in the tracepoint? That is:
> 
> 	TP_PROTO(struct lruvec *lruvec,
> 		 struct scan_control *sc,
> 		 struct lru_gen_folio *lrugen,
> 		 unsigned long nr_requested,
> 		 unsigned long nr_scanned,
> 		 unsigned long nr_sorted,
> 		 unsigned long nr_skipped,
> 		 unsigned long nr_taken,
> 		 int type),
> 
> 	TP_ARGS(lruvec, sc, lrugen, nr_requested, nr_scanned,
> 		nr_sorted, nr_skipped, nr_taken, type),
> 
> 	TP_STRUCT__entry(
> 		__field(u64, memcg_id)
> 		__field(int, highest_zoneidx)
> 		__field(int, order)
> 		__field(unsigned long, nr_requested)
> 		__field(unsigned long, nr_scanned)
> 		__field(unsigned long, nr_sorted)
> 		__field(unsigned long, nr_skipped)
> 		__field(unsigned long, nr_taken)
> 		__field(unsigned long, max_seq)
> 		__field(unsigned long, min_seq)
> 		__field(int, lru)
> 		__field(int, tier)
> 	),
> 
> 	TP_fast_assign(
> 		__entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
> 		__entry->highest_zoneidx = sc->reclaim_idx;
> 		__entry->order = sc->order;
> 		__entry->nr_requested = nr_requested;
> 		__entry->nr_scanned = nr_scanned;
> 		__entry->nr_sorted = nr_sorted;
> 		__entry->nr_skipped = nr_skipped;
> 		__entry->nr_taken = nr_taken;
> 		__entry->lru = type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON;
> 		__entry->max_seq = lrugen->max_seq;
> 		__entry->tier = tier;
> 		__entry->min_seq = lrugen->min_seq;
> 	),
> 
> 
> This moves the code to generate the parameters into the TP_fast_assign()
> which is in a separate text section. It remove code from the work flow
> improving instruction cache.
> 
> Same can be done for that trace_mm_vmscan_lru_isolate() trace event.
> 

Sashiko has reported the same issue, so I updated my series [1] when I received 
Sashiko's report. Thank you again for pointing this out.

[1] https://lore.kernel.org/linux-mm/20260911102939.2485750-3-ridong.chen@linux.dev/

> 
>>   
>>   	*isolatedp = isolated;
>>   	return scanned;
>> -- 

-- 
Best regards
Ridong


