Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51153C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 09:04:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 372616B0088; Mon, 14 Sep 2026 05:04:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FDA96B008C; Mon, 14 Sep 2026 05:04:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C63C6B0092; Mon, 14 Sep 2026 05:04:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E41916B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 05:04:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 38378140114
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:04:46 +0000 (UTC)
X-FDA: 85211782572.29.01804D9
Received: from mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6471A100003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:04:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BEteMCVW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789376684;
	b=2jBtrRFab0m6fxflZ/tZX9jaidCSAeLKj7ciUU8V1dUJ3qTMevoY57NGQQAr3behsVsZ9W
	zG77JMs1tSEvImrIUtIkq+MrdNqrkofZTgbzAS9x2ZOlqZv0LSn7Mrx98cjqx4W3ylPQdO
	oKevq46YxZRNOh30Yw4U925X5Wu57oE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BEteMCVW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789376684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O1wgHE2Exj7vwtzsmNOFsEQLTE+Oq9gexDpFJN7yUms=;
	b=BhtzJ7sm+UH//jAnh/+wkJrEqwclxpv5QVHIWFufX/Q0h+xxf2W9SPjyk/NzKrGMy4XQc7
	daW0HU0U1Fr9/1F3AKHHtdJ1iwvsSSwFX+5/2PhMINzEJpZYh3syjSTmeZcW1GsOK7hMOY
	bUQ3dCQX42Uf5r4QKhRPWOzb6/4XH9A=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cyHRGG1jP0E/7LSzChuUoiK/6HUy6jQ8rWqx8S/GEFs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789376681; v=1; x=1789981481;
 b=BEteMCVWd56/AC6D47UbBT9CFGQwz7GFuTCbIKz1imFLAqkHq4Prq4ohtE3jTAuiyERyx9lC
 PX7NYxz15QZQzu2nIydA8HJ5wxSr10hFeioqB48B7SnAc4Wnv4Q7oipkYTew0L9bWmwcvZgFd72
 OfJCef3vgvbzAEMJWo/qygrE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b890552444941dff;
	Mon, 14 Sep 2026 09:04:40 +0000
X-Mizu-Trace-ID: b890552444941dff
X-Migadu-Flow: FLOW_OUT
Message-ID: <fb8d932f-2dd9-442d-b829-575acf8480f8@linux.dev>
Date: Mon, 14 Sep 2026 17:04:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm/mglru: add tracepoint for scan_folios()
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org,
 "open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260911102939.2485750-1-ridong.chen@linux.dev>
 <20260911102939.2485750-3-ridong.chen@linux.dev>
 <9c8c7c91-b159-4342-8af7-3a8171e85389@linux.alibaba.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <9c8c7c91-b159-4342-8af7-3a8171e85389@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6471A100003
X-Stat-Signature: n4ybjfz9zrgokw78rk8yszkii4wmcymy
X-HE-Tag: 1789376682-135280
X-HE-Meta: U2FsdGVkX1+QoO4ZE3Qvzb8Qmu1vVF5XPDbY4C9RBbSziKVweXNWXkgoSW/rV9kDtos7iP+hPu7SeWnnyWOPv/2zPFKjcRWdeoZ9ISVT5B05HKq++Lj+dndmrKp2jPH+x4jq14mh53l3CI+KX2SB27UY6axFy/8FmpbO6d6YRxLakAGyD/BOV1zXgWyab4FYCEG9KSlK1ei0bOqdrWeB10LdPzXHt/cb8Nzyjn6KKeMjqf6E+zQ0Vwi7Cz9C50SpMrcCBl1B7j08U/4SVpysDYdND5gUSSADJo3wPoefynEzegM/gnwuVUdBUx+iuf3IkLSFsgJQEJ5DgaIxNvIW6V3wIpbw5ibcpuxXRPm/zqjg7w5z2N2xtnaNr8wRlonIqicovkODmKE0kQxLEQPHlqo4h8GlApQu6NAIXxPcN20yKejvrawCdPSFJOWbKe+ObGxuSoXuhdafTAR6gxma4lX9zMqHlHx2m9Hqno8LACdHISljXLQVZ1G9YjgZsStWjaVTIRnmuZEX1hTs1f5assZjBj0MSL5YuCRTZBa2XTSlfRiEbSZDyzKd56BGPfKHRWAGFj2LPW9WHLPv7LDqRlFKbtJlHjbS6Ao5iJp2ffXZqIIYPN8lD+kdOSDuLSxnUm7u4qVJ1ufIftmZG+WZmIaJd7RWq2/bXI24VJCzBWVmsRYqFnm9XOnNL/pJoxTM8d/qRtUa6RJKQFWw9OMy85ofPrHEHIYvUlj/OTeAGKrVyVau61YVcQ2NZO5Lespeo2IHGkRSPCQlDYm45JgOxbdm2qV0PKZV3KaDvWA6JGu/9/YJKyVuLWPW7eNo3v1sCqJ50qwSZVlQqAWdjWi1VrExp4A5nFQyJM9DvJ8QHeA4AcRN6qOaZ3sNJezY3UCnE6qK9r2boeRg6mDVsMhUEQsrn3eQ7KUh3lBhrUxyOEh7FG7VWGjNhtSBjKf9gnCvMc3BeSLi9e3cfVLWby1
 r8RPf3vi
 JmHNgTMDJqUNewLpFRzh2UmQFixjIAvbCXNm2BoYRRi3OtQmZ658k7QBgy5xE0dCXAYQj71PR06UwB9GLyC8YSx8KmkaOkN03ljiyNKx/nGHYPPUR+KHDcRmGp8r1V5kMpBZK8ij9jcXahX0y9hLkQ1K5pxVIgJiXAAicAn5J8LsPrku4CAXwbUjU/jHybhCFs0n4Zl3kWcuMk1cFolOiD8To9HQRRqZ5ul1Sy65mgFHCBCh/BZDNtWF/vaCYPmWwT4YV/uUSeoRHrQ7JX7PZjtwai27S87AasxBHv8IZajjI8yYcp1fYlhiozWnOeWVtiyeDrpbcmDmvsyeW+f265H59y2tUAXJ14jw47e2BGL5WTJEsXghJqM7TIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/14/2026 3:47 PM, Baolin Wang wrote:
> 
> 
> On 9/11/26 6:29 PM, Ridong Chen wrote:
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> MGLRU's scan_folios() emits the classic-LRU tracepoint
>> trace_mm_vmscan_lru_isolate(), which predates MGLRU. It reports the
>> scan/isolate counts and the LRU type, but carries no generation or
>> memcg context, so a trace of an MGLRU run cannot tell which memcg a
>> given scan belongs to, nor how far reclaim has progressed through the
>> generations.
>>
>> Add mm_mglru_scan_folios next to it, reporting the same counters plus
>> nr_sorted (folios moved to a younger generation by sort_folio()) and
>> the MGLRU context the classic tracepoint lacks: the memcg id, and the
>> max_seq, tier and min_seq of the type being scanned.
>>
>> scan_folios() is the MGLRU-specific layer where folios are actually
>> scanned, so it has no classic-LRU counterpart. That the classic
>> trace_mm_vmscan_lru_isolate() has lived here stably shows this is a
>> long-lived place to hook, and the new tracepoint can be enabled on its
>> own to observe the MGLRU-specific information. The existing tracepoint
>> is left unchanged.
>>
>> Assisted-by: Claude:claude-opus-4-8
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   include/trace/events/vmscan.h | 63 +++++++++++++++++++++++++++++++++++
>>   mm/vmscan.c                   |  6 ++++
>>   2 files changed, 69 insertions(+)
>>
>> diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
>> index 8a872990b4be..5defa8f6719c 100644
>> --- a/include/trace/events/vmscan.h
>> +++ b/include/trace/events/vmscan.h
>> @@ -392,6 +392,69 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
>>           __print_symbolic(__entry->lru, LRU_NAMES))
>>   );
> 
> [snip]
> 
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 2554a6513aa8..67f59aa73fb9 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -4876,6 +4876,12 @@ static int scan_folios(unsigned long nr_to_scan, struct 
>> lruvec *lruvec,
>>       trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
>>                   scanned, skipped, isolated,
>>                   type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>> +    trace_mm_mglru_scan_folios(lruvec,
>> +                   sc->reclaim_idx, sc->order, nr_to_scan,
>> +                   scanned, sorted, skipped, isolated,
>> +                   type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON,
>> +                   lrugen->max_seq, tier,
>> +                   lrugen->min_seq[type]);
> 
> Both tracepoints will print some duplicated content, and I'm not sure it's worth 
> a new tracepoint just to trace max_seq and min_seq.
> 
> Anyway, I'm not against this patch, but I'd like to hear others' opinions.

Thank you for your review.

Since the lruvec is per memcg and per node, we would like to know how the memcg 
scans and reclaims its lruvec.

I am also concerned that the content may be duplicated where we place it here. 
However, with Barry's suggestion, it is stable here. What is more, the trace is 
under the control of the trace event gate. It is convenient to control and would 
not lead to any regression when they are disabled.

As my cover letter mentions, with the current trace events, we don't know when 
the per-memcg lruvec ages, when it is scanned and reclaimed, or with what 
seq(gen). With this series, we can tell the memcg aging and reclaim actions.

-- 
Best regards
Ridong


